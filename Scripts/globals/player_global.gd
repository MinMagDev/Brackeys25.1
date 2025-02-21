extends Node

var max_health : int = 20
var cur_health : int = 20

var player_score : int = 0

func damage(amount: int):
	cur_health = max(0, cur_health - amount)
	player_score -= amount
	print("Took damage, current hp: "+  str(cur_health) + "And current score : ", player_score)
	if cur_health == 0:
		print("You are Dead")
		get_tree().quit()

func heal(amount: int):
	cur_health = min(max_health, cur_health + amount)
	player_score += amount
