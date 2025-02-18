extends CharacterBody2D

class_name Enemy

var max_health := 20
var cur_health : int

var damage := 2
var armor := 1

var speed := 200.0

static var enemy_scn = preload("res://scenes/enemy.tscn")

static func new_enemy(start_position := Vector2.ZERO, \
					start_health := 20, \
					enemy_damage := 2,  \
					enemy_armor := 1,   \
					enemy_speed := 200.0) -> Enemy:
	var new_enemy = enemy_scn.instatiate()
	new_enemy.position   = start_position
	new_enemy.max_health = start_health
	new_enemy.cur_health = start_health
	new_enemy.damage     = enemy_damage
	new_enemy.armor      = enemy_armor
	new_enemy.speed      = enemy_speed
	return new_enemy

func _on_deal_damage(damage: int) -> void:
	print("Outch, lost: ", damage)
	cur_health -= damage
	print("Health: ", cur_health)
	if cur_health <= 0:
		die()

func die() -> void:
	queue_free()
