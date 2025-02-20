extends Area2D

signal enter_room(room : Vector2)

var is_open : bool = false
var leads_to_room : Vector2 
@export
var in_room_position: int
#INFO: 
			# 0 = Left
			# 1,2,3 = Up (either 1 and 2) or only 3 in one room
			# 4 = right
			# 5 = down_back

func _ready() -> void:
	if in_room_position == 4:
		$OpenDoor.rotation = PI 
		$ClosedDoor.rotation = PI
	elif in_room_position == 5:
		$OpenDoor.rotation = (3*PI)/2
		$ClosedDoor.rotation = (3*PI)/2

func set_is_open(value: bool) -> void:
	is_open = value
	$ClosedDoor.visible = is_open
	

func _on_body_entered(body: Node2D) -> void:
	if is_open:
		enter_room.emit(leads_to_room)
	
	set_is_open(not is_open)
