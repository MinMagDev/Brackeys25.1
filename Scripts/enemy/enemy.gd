extends CharacterBody2D

class_name Enemy

var type : EnemyTypes = EnemyTypes.BASIC
var cost : int        = 1

var max_health : int = 20
var cur_health : int = 20

var damage : int = 2
var armor  : int = 1

var speed : float = 170.0

static var enemy_scn   : PackedScene = preload("res://scenes/enemy.tscn")
static var strider_scn : PackedScene = preload("res://scenes/enemys/strider.tscn")

enum EnemyTypes {
	BASIC,
	STRIDER
}

var strider_enemy : Dictionary


static func new_enemy(args = [EnemyTypes.BASIC, 1 ,20, 2, 1, 200.0]) -> Enemy:
					#enemy_type     : EnemyTypes = EnemyTypes.BASIC, 0
					#enemy_cost     : int        = 1,				1
					#start_health   : int        = 20, 				2
					#enemy_damage   : int        = 2,  				3
					#enemy_armor    : int        = 1,   				4
					#enemy_speed    : float      = 200.0				5
	var new_enemy = get_enemy_scn(args[0]).instantiate()
	new_enemy.cost       = args[1]
	new_enemy.max_health = args[2]
	new_enemy.cur_health = args[2]
	new_enemy.damage     = args[3]
	new_enemy.armor      = args[4]
	new_enemy.speed      = args[5]
	return new_enemy

	
func _process(delta: float) -> void:
	enemy_ai(delta)

func enemy_ai(delta: float):
	enemy_move(delta)
	enemy_attack()

func enemy_move(delta: float):
	pass

func enemy_attack():
	pass

func attack_player(damage: int):
	PlayerGlobal.damage(damage)

static func get_enemy_scn(enemy_type: EnemyTypes) -> PackedScene:
	match enemy_type:
		EnemyTypes.STRIDER:
			return strider_scn
	return enemy_scn


func _on_deal_damage(damage: int) -> void:
	print("Outch, lost: ", damage)
	damage = damage - armor
	cur_health -= damage
	print("Health: ", cur_health)
	if cur_health <= 0:
		die()

func die() -> void:
	queue_free()
