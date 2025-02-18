extends RigidBody2D

class_name Projectile

const SPEED := 300.0

static var bullet_scn := preload("res://scenes/bullet.tscn")

var direction : Vector2

# Constructor für Projektile
static func new_projectile(start_position := Vector2(0,0), start_direction := Vector2(1,0)) -> Projectile:
	var new_projectile = bullet_scn.instantiate()
	new_projectile.global_position = start_position
	new_projectile.direction = start_direction
	return new_projectile
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir := direction * delta * SPEED
	if move_and_collide(dir):
		queue_free()
