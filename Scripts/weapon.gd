extends Area2D

signal shoot_bullet(start_position: Vector2, direction: Vector2)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var weapon_direction = get_weapon_direction() * ArtifactGlobal.pistol_offset
	var to_rotate = get_weapon_rotation(weapon_direction) 
	rotate(to_rotate)
	if Input.is_action_just_pressed("Attack"):
		var spawn_pos = $SpawnPointer.global_position
		shoot_bullet.emit(spawn_pos, weapon_direction)

# Calculate the direction in which the weapon should face
func get_weapon_direction() -> Vector2:
	var direction_vector := get_global_mouse_position() - global_position
	return direction_vector.normalized()
	
# Calculate the weapon rotation from a direction Vector
func get_weapon_rotation(direction_vector: Vector2) -> float:
	var rotation_from_direction = atan2(direction_vector.y, direction_vector.x) + PI/2
	return rotation_from_direction - rotation
	
