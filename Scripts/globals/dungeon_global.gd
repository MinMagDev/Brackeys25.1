extends Node

var up_door_scn :=   preload("res://scenes/up_door.tscn")
var side_door_scn := preload("res://scenes/up_door.tscn")

enum  Difficulty {
	EASY,
	NORMAL,
	HARD
}

func generate_dungeon(dungeon_size: int) -> Array[DungeonRoom]:
	var dungeon_layout := generation_worker(dungeon_size, 1, [])
	return dungeon_layout

func generation_worker(depth: int, rooms_in_layer:int, acc: Array[DungeonRoom]) -> Array[DungeonRoom]:
	return acc

class Door:
	var door_position: Dictionary
	var leads_to_room: DungeonRoom
	var door_node: Node2D
	
	func set_position(room: DungeonRoom, in_room_position: int):
		door_position = {
			"room" : room,
			"in_room_position": in_room_position
		}
	
	func _init(_door_position: Dictionary, _leads_to_room: DungeonRoom, _door_node) -> void:
		door_position =_door_position
		leads_to_room = _leads_to_room
		door_node = _door_node
		door_node.leads_to_room = leads_to_room

class DungeonRoom:
	var doors : Array[Door]
	var coordinate : Vector2
	
	func _init(_doors: Array[Door], _coordinate: Vector2) -> void:
		doors = _doors
		coordinate = _coordinate

#------------------------------------------------------------------------
#Different room Types
class EntranceRoom extends DungeonRoom:
	var artifact: int
	
	func _init(_doors: Array[Door], _coordinate: Vector2, _artifact: int) -> void:
		artifact = _artifact
		super(_doors, _coordinate)

class EnemyRoom extends DungeonRoom:
	var room_difficulty: Difficulty
	var enemys: Array[Node2D]
	
	func _init(_doors: Array[Door], _coordinate: Vector2, _difficulty: Difficulty) -> void:
		room_difficulty = _difficulty
		enemys = generate_monsters()
		super(_doors, _coordinate)
	
	func generate_monsters():
		return []
