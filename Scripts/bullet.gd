extends RigidBody2D

const SPEED := 300.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir := Vector2(1,0) * delta * SPEED
	move_and_collide(dir)
