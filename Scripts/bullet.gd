extends RigidBody2D

class_name Projectile

signal deal_damage(amount: int)

const SPEED := 450.0

static var bullet_scn := preload("res://scenes/bullet.tscn")

var direction : Vector2
var damage: int

# Constructor für Projektile
static func new_projectile(start_position := Vector2(0,0), \
						  start_direction := Vector2(1,0), \
						  proj_damage := 10) -> Projectile:
	var new_projectile = bullet_scn.instantiate()
	new_projectile.global_position = start_position
	new_projectile.direction = start_direction
	new_projectile.damage = proj_damage
	return new_projectile
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir := direction * delta * SPEED
	var collider = move_and_collide(dir)
	if collider:
		var collision_object = collider.get_collider()
		if collision_object in get_tree().get_nodes_in_group("Enemys"):
			deal_damage.connect(collision_object._on_deal_damage)
			deal_damage.emit(damage)
		queue_free()

	
