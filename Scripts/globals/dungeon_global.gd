extends Node

var up_door_scn   := preload("res://scenes/up_door.tscn")
var side_door_scn := preload("res://scenes/up_door.tscn")

var exit_room_exists : bool = false

var rooms_in_next_layer : int = 1

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
	
	print(" New Layer: ", depth)
	rooms_in_next_layer = 1
	#Generate Rooms in a Layer
	for i in range(0,rooms_in_layer):
		print("Yay new room")
		var left_door :bool = false
		if i != 0:
			left_door = acc.back().has_right_door
		var new_room = generate_room(depth, i + 1, rooms_in_layer, left_door)
		acc.append(new_room)
	return generation_worker(depth - 1, rooms_in_next_layer, acc)

func generate_room(layer: int, room_number: int, rooms_in_layer: int, left_door: bool) -> DungeonRoom:
	var is_exit_room: bool = (randi_range(1, layer) == 1) and not exit_room_exists
	var coordinate = Vector2(layer, room_number)
	if is_exit_room: 
		exit_room_exists = true
		return ExitRoom.new([], coordinate)
	var room_type = room_distriubution[randi_range(0, room_distriubution.size() - 1)]
	var new_room : DungeonRoom
	
	var right_door_possible : bool = rooms_in_layer != room_number
	var doors : Array[Door] = generate_doors(layer, room_number, left_door, right_door_possible)
	match room_type:
		RoomTypes.ENEMY:
			new_room = EnemyRoom.new(doors, coordinate)
			
		RoomTypes.TREASURE:
			new_room = TreasureRoom.new(doors, coordinate)
			pass
	
	return new_room

func generate_doors(layer: int,
					room_in_layer: int, 
					left_door: bool , 
					right_door_possible: bool
					) -> Array[Door]:
	var doors : Array[Door] = []
	if left_door:
		var new_door = Door.new(
			Vector2(layer, room_in_layer - 1),
			side_door_scn.instantiate()
			)
		new_door.set_position(Vector2(layer, room_in_layer), 0)
		doors.append(new_door)
	
	#Second Up Door?
	if randi_range(0,3) == 0:
		for i in range(1):
			var new_door = Door.new(
				Vector2(layer - 1, rooms_in_next_layer),
				side_door_scn.instantiate()
			)
			new_door.set_position(Vector2(layer, room_in_layer), 1 + i*2)
			doors.append(new_door)
			rooms_in_next_layer += 1
	else: #The only one door
		var new_door = Door.new(
			Vector2(layer - 1, rooms_in_next_layer),
			side_door_scn.instantiate()
		)
		new_door.set_position(Vector2(layer, room_in_layer), 2)
		doors.append(new_door)
		rooms_in_next_layer += 1
	
	# Possiblity to create a doorway to the adjacent right room
	if right_door_possible and randi_range(0,4) == 0:
		var new_door = Door.new(
			Vector2(layer, room_in_layer + 1),
			side_door_scn.instantiate()
		)
		new_door.set_position(Vector2(layer, room_in_layer), 4)
		doors.append(new_door)
	return doors


func print_dungeon(dungeon: Array[DungeonRoom]) -> void:
	var count = 0
	for room in dungeon:
		print("Room Number: " + str(count))
		print("Is in layer: " + str(room.coordinate.x) + " at position: "+ str(room.coordinate.y))
		print("It is from the type: " + str(room.get_type()))
		print("Amount of doors: " + str(room.doors.size()))
		print("The rooms lead to: ")
		var door_count = 0
		for door in room.doors:
			print("    Door number: " + str(door_count))
			print("    Position in room: " + str(door.door_position["in_room_position"]))
			print("    Leads to: " + str(door.leads_to_room))
			door_count += 1

#---------------------------------------------------------
#CLASSES
#---------------------------------------------------------
class Door:
	var door_position: Dictionary
	var leads_to_room: Vector2
	var door_node: Node2D
	
	func set_position(room: Vector2, in_room_position: int):
		door_position = {
			"room" : room,
			
			#INFO: 
			# 0 = Left
			# 1,2,3 = Up (either 1 and 2) or only 3 in one room
			# 4 = right
			"in_room_position": in_room_position
	
		}
	
	func _init(_leads_to_room: Vector2, _door_node) -> void:
		leads_to_room = _leads_to_room
		door_node = _door_node
		door_node.leads_to_room = leads_to_room

class DungeonRoom:
	var doors : Array[Door]
	var coordinate : Vector2
	var has_right_door: bool
	
	func _init(_doors: Array[Door], _coordinate: Vector2) -> void:
		doors = _doors
		coordinate = _coordinate
	
	func get_type() -> String:
		return "base"

#------------------------------------------------------------------------
#Different room Types
class EntranceRoom extends DungeonRoom:
	var artifact: int
	
	func _init(_doors: Array[Door], _coordinate: Vector2, _artifact: int) -> void:
		artifact = _artifact
		super(_doors, _coordinate)
	
	func get_type() -> String:
		return "EntranceRoom"

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
		
	
	func generate_monsters() -> Array[Node2D]:
		#TODO Generate Monsters in Enemey Room
		return []
	
	func get_type() -> String:
		return "EnemyRoom"

class TreasureRoom extends DungeonRoom:
	var treasure_rarity: int
	
	func _init(_doors: Array[Door], _coordinate: Vector2) -> void:
		generate_treasure()
		super(_doors, _coordinate)
	
	func generate_treasure():
		#TODO: Whole Treasure System Lol
		treasure_rarity = 1
	
	func get_type() -> String:
		return "TreasureRoom"


class ExitRoom extends DungeonRoom:
	func _init(_doors: Array[Door], _coordinate: Vector2):
		doors = []
		coordinate = _coordinate
		
	func get_type() -> String:
		return "ExitRoom"
