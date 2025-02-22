extends Node

var up_door_scn   := preload("res://scenes/up_door.tscn")
var side_door_scn := preload("res://scenes/side_door.tscn")

var exit_room_exists : bool = false

var rooms_in_next_layer     : int
var in_rooms_doors : Array[Vector2] = [Vector2(-1, -1)]

var current_dungeon : Array[DungeonRoom]

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
	var doors_in_previous_layer = in_rooms_doors
	in_rooms_doors = []
	print(" New Layer: ", depth)
	rooms_in_next_layer = 0
	#Generate Rooms in a Layer
	for i in range(0, rooms_in_layer):
		print("Yay new room")
		var left_door :bool = false
		if i != 0:
			left_door = acc.back().has_right_door
		var new_room = generate_room(depth, i, rooms_in_layer, left_door, acc.size())
		new_room.created_by_room = doors_in_previous_layer[i]
		acc.append(new_room)
	return generation_worker(depth - 1, rooms_in_next_layer, acc)

func generate_room(layer: int, room_number: int, rooms_in_layer: int, left_door: bool, room_count: int) -> DungeonRoom:
	var is_exit_room: bool = (randi_range(1, layer) == 1) and \
							 not exit_room_exists and  \
							 room_count >= layer*layer
							 
	var coordinate = Vector2(layer, room_number)
	var room_type = room_distriubution[randi_range(0, room_distriubution.size() - 1)]
	var new_room : DungeonRoom
	
	var right_door_possible : bool = rooms_in_layer != room_number + 1
	var doors : Array[Door] = generate_doors(layer, room_number, left_door, right_door_possible, is_exit_room)
	if is_exit_room: 
		exit_room_exists = true
		return ExitRoom.new(doors, coordinate)
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
					right_door_possible: bool,
					is_exit_room: bool
					) -> Array[Door]:
	var doors : Array[Door] = []
	
	# Possiblity to create a doorway to the adjacent right room
	if right_door_possible and randi_range(0,2) == 0:
		doors.append(create_door(Vector2(layer, room_in_layer + 1),
									 Vector2(layer, room_in_layer), 
									 4,
									 side_door_scn))
	
	if left_door:
		doors.append(create_door(Vector2(layer, room_in_layer - 1),
									 Vector2(layer, room_in_layer), 
									 0,
									 side_door_scn))
		
	if layer == 1 or is_exit_room:
		return doors
		
	#Second Up door
	if randi_range(0,1) == 0:
		for i in range(2):
			var in_room_pos = 1 + i*2
			doors.append(create_door(Vector2(layer - 1, rooms_in_next_layer),
									 Vector2(layer, room_in_layer),
									 in_room_pos,
									 up_door_scn))
	else: #The only one door
		doors.append(create_door(Vector2(layer-1, rooms_in_next_layer),
								 Vector2(layer, room_in_layer),
								 2,
								 up_door_scn))
		
	return doors

func create_door(leads_to: Vector2, room_position: Vector2, in_position: int, door_scn: PackedScene) -> Door:
	if in_position in [1,2,3]:
		in_rooms_doors.append(room_position)
		print("Doors in previous Layer: ", in_rooms_doors)
		rooms_in_next_layer += 1
	var door_node = door_scn.instantiate()
	door_node.in_room_position =  in_position
	var new_door = Door.new(
		leads_to,
		door_node
	)
	new_door.set_position(room_position, in_position)
	return new_door
	
func get_room_at_coordinate(coordinate: Vector2, dungeon: Array[DungeonRoom]) -> DungeonRoom:
	for room in dungeon:
		if coordinate == room.coordinate:
			return room
	print_debug("Room at " + str(coordinate) + " not found")
	return
	


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
		if room.get_type() == "EnemyRoom":
			print("Enemys:    count: " , room.enemys.size())
			var enemy_count = 0
			for enemy in room.enemys:
				print("    Enemy number: ", enemy_count)
				print("          Has the cost: ", enemy.cost)
				enemy_count +=1
		print("------------------------------------")
		print(" ")
		count += 1

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
	var doors           : Array[Door]
	var coordinate      : Vector2
	var has_right_door  : bool
	var created_by_room : Vector2
	
	func _init(_doors: Array[Door], _coordinate: Vector2) -> void:
		doors = _doors
		coordinate = _coordinate
		if doors.size() == 0:
			has_right_door = false
			return
		has_right_door = doors[0].door_position["in_room_position"] == 4
	
	func get_type() -> String:
		return "base"

#------------------------------------------------------------------------
#Different room Types
class EntranceRoom extends DungeonRoom:
	var artifact: int
	
	func _init(_doors: Array[Door], _coordinate: Vector2) -> void:
		artifact = ArtifactGlobal.generate_artifact() #TODO: Jeah Artifacts or so
		super(_doors, _coordinate)
	
	func get_type() -> String:
		return "EntranceRoom"

class EnemyRoom extends DungeonRoom:
	var room_difficulty: Difficulty
	var enemys: Array[Enemy]
	
	
	func _init(_doors: Array[Door], _coordinate: Vector2) -> void:
		room_difficulty = generate_difficulty()
		enemys = EnemyGlobal.generate_monsters(room_difficulty)
		super(_doors, _coordinate)
		
	#Generate the room difficulty for Enemy Rooms
	func generate_difficulty() -> Difficulty:
		var room_diffculty : Difficulty
		match randi_range(0, 4):
			0:     room_diffculty = Difficulty.EASY
			1,2,3: room_diffculty = Difficulty.NORMAL
			4:     room_diffculty = Difficulty.HARD
		return room_diffculty
		
	
	func get_type() -> String:
		return "EnemyRoom"

class TreasureRoom extends DungeonRoom:
	var treasure_scn
	
	#Treasure Scenes
	var heal_scn := preload("res://scenes/heal.tscn")
	var money_scn := preload("res://scenes/money.tscn")
	
	func _init(_doors: Array[Door], _coordinate: Vector2) -> void:
		generate_treasure()
		super(_doors, _coordinate)
	
	func generate_treasure():
		if randi_range(0,2) == 0:
			treasure_scn = heal_scn
		else:
			treasure_scn = money_scn
	
	func get_type() -> String:
		return "TreasureRoom"


class ExitRoom extends DungeonRoom:
	func _init(_doors: Array[Door], _coordinate: Vector2):
		doors = []
		coordinate = _coordinate
		
	func get_type() -> String:
		return "ExitRoom"
