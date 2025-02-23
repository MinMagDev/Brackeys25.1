extends Node

var easy_strider   : Array
var normal_strider : Array
var hard_strider   : Array
var bulky_strider  : Array
var enemy_sets     : Array

func _ready() -> void:
	easy_strider   = [Enemy.EnemyTypes.STRIDER, 1, 10, 1, 0, 100.0]
	normal_strider = [Enemy.EnemyTypes.STRIDER, 2, 15, 2, 1, 150.0]
	hard_strider   = [Enemy.EnemyTypes.STRIDER, 3, 20, 3, 1, 200.0]
	bulky_strider  = [Enemy.EnemyTypes.STRIDER, 4, 30, 3, 2, 200.0]
	
	enemy_sets = [
		[easy_strider, normal_strider, hard_strider],
		[easy_strider, bulky_strider]
	]

func generate_monsters(room_difficulty) -> Array[Enemy]:
		var enemy_points : int
		match room_difficulty:
			DungeonGlobal.Difficulty.EASY:
				enemy_points = 4
			DungeonGlobal.Difficulty.NORMAL:
				enemy_points = randi_range(5,7)
			DungeonGlobal.Difficulty.HARD:
				enemy_points = 8
		
		var enemys : Array[Enemy]
		var enemy_set : Array = enemy_sets[randi_range(0,enemy_sets.size() - 1)]
		# Get enemys based on cost
		while enemy_points > 0:
			var enemy_from_set =  Enemy.new_enemy(enemy_set[randi_range(0, enemy_set.size() - 1)])
			var enemy_cost = enemy_from_set.cost
			if enemy_cost <= enemy_points:
				enemys.append(enemy_from_set)
				enemy_points -= enemy_cost
			else: 
				enemy_set.erase(enemy_from_set)
		return enemys
