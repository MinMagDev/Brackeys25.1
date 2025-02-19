extends Node

var up_door_scn :=   preload("res://scenes/up_door.tscn")
var side_door_scn := preload("res://scenes/up_door.tscn")

var exit_room_exists := false

enum  Difficulty {
	EASY,
	NORMAL,
	HARD
}

enum  RoomTypes {
	ENTRANCE,
	ENEMY,
	TREASURE,
	EXIT
}

var room_distriubution := [
	RoomTypes.ENEMY,
	RoomTypes.ENEMY,
	RoomTypes.TREASURE
]

var extra_doors_in_room := [false, false, false]

func generate_dungeon(dungeon_size: int) -> Array[DungeonRoom]:
	exit_room_exists = false
	var dungeon_layout := generation_worker(dungeon_size, 1, [])
	return dungeon_layout

func generation_worker(depth: int, rooms_in_layer:int, acc: Array[DungeonRoom]) -> Array[DungeonRoom]:
	if depth == 0:
		return acc
	for i in range(0,rooms_in_layer):
		var new_room = generate_room(depth, i)
		acc.append(new_room)
	#TODO: Rekursion des Room-Workers
	return acc

func generate_room(layer: int, room_number: int) -> DungeonRoom:
	var is_exit_room: bool = (randi_range(1, layer) == 1) and not exit_room_exists
	var coordinate = Vector2(layer, room_number)
	if is_exit_room: 
		exit_room_exists = true
		return ExitRoom.new([], coordinate)
	var room_type = room_distriubution[randi_range(0, room_distriubution.size() - 1)]
	var new_room : DungeonRoom
	
	var doors = generate_doors()
	match room_type:
		RoomTypes.ENEMY:
			new_room = EnemyRoom.new(doors, coordinate)
			
		RoomTypes.TREASURE:
			new_room = TreasureRoom.new(doors, coordinate)
			pass
	
	return new_room

func generate_doors() -> Array[Door]:
	#TODO: Door Generator
	return []


#---------------------------------------------------------
#CLASSES
#---------------------------------------------------------
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
	
	func _init(_doors: Array[Door], _coordinate: Vector2) -> void:
		room_difficulty = generate_difficulty()
		enemys = generate_monsters()
		super(_doors, _coordinate)
		
	#Generate the room difficulty for Enemy Rooms
	func generate_difficulty() -> Difficulty:
		var room_diffculty : Difficulty
		match randi_range(0, 4):
			0:     room_diffculty = Difficulty.EASY
			1,2,3: room_diffculty = Difficulty.NORMAL
			4:     room_diffculty = Difficulty.HARD
		return room_diffculty
		
	
	func generate_monsters():
		#TODO Generate Monsters in Enemey Room
		return []

class TreasureRoom extends DungeonRoom:
	var treasure_rarity: int
	
	func _init(_doors: Array[Door], _coordinate: Vector2) -> void:
		generate_treasure()
		super(_doors, _coordinate)
	
	func generate_treasure():
		#TODO: Whole Treasure System Lol
		treasure_rarity = 1

class ExitRoom extends DungeonRoom:
	func _init(_doors: Array[Door], _coordinate: Vector2):
		doors = []
		coordinate = _coordinate
