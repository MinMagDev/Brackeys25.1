extends Node2D

var room : DungeonGlobal.DungeonRoom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	place_doors()

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
		$Doors.add_child(door_node)
