extends CharacterBody2D

signal shoot_bullet(start_position: Vector2, direction: Vector2)

const SPEED = 400.0

func _physics_process(delta: float) -> void:
	
	move_player(delta)

#Creates the player movement, 
func move_player(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("Left", "Right")
	direction.y = Input.get_axis("Up", "Down")
	
	#for fixing the diagonal speed
	direction = direction.normalized() * SPEED * delta * 100
	
	velocity.x = direction.x
	velocity.y = direction.y
	
	move_and_slide()

#Just a redirection
func _on_weapon_shoot_bullet(start_position: Vector2, direction: Vector2) -> void:
	shoot_bullet.emit(start_position, direction)
