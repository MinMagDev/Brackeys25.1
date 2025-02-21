extends Node2D

var room : DungeonGlobal.DungeonRoom

var is_fight_room: bool = false

signal enter_room(room: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	place_doors()
	var status = true
	if room.get_type() == "EnemyRoom":
		place_enemys()
		status = false
		is_fight_room = true
	elif room.get_type() == "TreasureRoom":
		var treasure = room.treasure_scn.instantiate()
		treasure.position = Vector2(0, 0)
		add_child(treasure)
	change_all_doors(status)
	$Doors/BackDoor.leads_to_room = room.created_by_room
	
func _process(_delta: float) -> void:
	if is_fight_room:
		if get_node("Enemys").get_children().size() == 0:
			change_all_doors(true)

func place_doors() -> void:
	for door in room.doors:
		print("Place new door in room", self)
		var door_node = door.door_node
		var in_room_position : int = door.door_position["in_room_position"]
		door_node.in_room_position = in_room_position
		var placement_coords : Vector2
		match in_room_position:
			0:
				placement_coords = $DoorMarker/LeftDoor0.position
			1:
				placement_coords = $DoorMarker/UpDoor1.position
			2:
				placement_coords = $DoorMarker/UpDoor2.position
			3:
				placement_coords = $DoorMarker/UpDoor3.position
			4:
				placement_coords = $DoorMarker/RightDoor4.position
		door_node.position = placement_coords
		door_node.enter_room.connect(_on_enter_room)
		$Doors.add_child(door_node)

func place_enemys() -> void:
	var count : int = 0
	var markers = get_node("EnemySpawns").get_children()
	for enemy in room.enemys:
		enemy.position ==  markers[count].position
		if enemy.get_parent():
			enemy.get_parent().remove_child(enemy)
		$Enemys.add_child(enemy)
		
func change_all_doors(status: bool) -> void:
	for door in get_node("Doors").get_children():
		door.set_is_open(status)

func _on_enter_room(room_to_enter: Vector2):
	print("MoOVVVE  ", room_to_enter)
	enter_room.emit(room_to_enter)
