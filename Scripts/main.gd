extends Node2D

var dungeon_room_scn : PackedScene = preload("res://scenes/dungeon.tscn")

func _on_player_shoot_bullet(start_position: Vector2, direction: Vector2) -> void:
	var projectile = Projectile.new_projectile(start_position, direction)
	$Projectiles.add_child(projectile)

func _ready() -> void:
	#print(str(DungeonGlobal.generate_dungeon(5).size()))
	var dungeon_depth :int = 7
	var dungeon = DungeonGlobal.generate_dungeon(dungeon_depth)
	DungeonGlobal.current_dungeon = dungeon
	#DungeonGlobal.print_dungeon(dungeon)
	place_generated_dungeon(dungeon)
	_on_enter_room(Vector2(dungeon_depth, 0))

func place_generated_dungeon(dungeon: Array[DungeonGlobal.DungeonRoom]) -> void:
	for room in dungeon:
		var room_node = dungeon_room_scn.instantiate()
		var room_position = Vector2(room.coordinate.y * 1200, room.coordinate.x * 700)
		room_node.room = room
		room_node.position = room_position
		room_node.enter_room.connect(_on_enter_room)
		$Rooms.add_child(room_node)

func get_room_node(room_pos: Vector2):
	var room_node
	for room in get_tree().get_nodes_in_group("Room"):
		var room_coord : Vector2  = room.room.coordinate
		if room_coord == room_pos:
			print("Found: ", room_coord)
			room_node = room
	
	return room_node

func _on_enter_room(room : Vector2) -> void:
	print("Enter room: ", room)
	var dungeon_room : Node2D = get_room_node(room)
	#print("Room Coord: ", dungeon_room.room.coordinate)
	var spawn_position : Vector2 = dungeon_room.get_node("CharacterMarker").global_position
	$Player.global_position = spawn_position
