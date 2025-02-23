extends Node2D
var room : DungeonGlobal.DungeonRoom
signal enter_room(room: Vector2)

var dungeon_depth: int = 5

func _ready() -> void:
	var in_door:= DungeonGlobal.Door.new(Vector2(dungeon_depth, 0), $Doors/InDoor)
	in_door.set_position(Vector2(-42,-42),2)
	room = DungeonGlobal.EntranceRoom.new(
		[in_door],
		Vector2(-42,-42)
	)
	$Doors/OutDoor.leads_to_room = Vector2(-42,-42)
	$Doors/OutDoor.set_is_open(true)
	$Altar.set_artifact(room.artifact)
	

func _on_enter_room(room_to_enter: Vector2):
	print("Mooove  ", room_to_enter)
	enter_room.emit(room_to_enter)


func _on_altar_start() -> void:
	$Doors/OutDoor.set_is_open(false)
	$Doors/InDoor.set_is_open(true)
	$StoryLabel.visible = true
