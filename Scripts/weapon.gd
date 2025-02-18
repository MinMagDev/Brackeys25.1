extends Area2D

signal shoot_bullet(start_position: Vector2, direction: float)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var to_rotate = get_weapon_rotation()
	rotate(to_rotate)
	if Input.is_action_just_pressed("Attack"):
		var spawn_pos = $SpawnPointer.global_position
		shoot_bullet.emit(spawn_pos, to_rotate)

func get_weapon_rotation() -> float:
	var direction_vector := get_global_mouse_position() - global_position
	direction_vector = direction_vector.normalized()
	var rotation_from_direction = atan2(direction_vector.y, direction_vector.x) + PI/2
	return rotation_from_direction - rotation
	
