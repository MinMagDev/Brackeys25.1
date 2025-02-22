extends Node2D
var room : DungeonGlobal.DungeonRoom
signal enter_room(room: Vector2)

var dungeon_depth: int = 7

func _ready() -> void:
	var in_door:= DungeonGlobal.Door.new(Vector2(dungeon_depth, 0), $Doors/InDoor)
	in_door.set_position(Vector2(-1,-1),2)
	room = DungeonGlobal.EntranceRoom.new(
		[in_door],
		Vector2(-1,-1),
		0
	)
	

func _on_enter_room(room_to_enter: Vector2):
	print("Mooove  ", room_to_enter)
	enter_room.emit(room_to_enter)


func _on_altar_start() -> void:
	$Doors/OutDoor.set_is_open(false)
	$Doors/InDoor.set_is_open(true)


func _on_ienter_room(room: Vector2) -> void:
	pass # Replace with function body.
