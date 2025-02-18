extends Node

var max_health := 20
var cur_health := 20

func damage(amount: int):
	cur_health = max(0, cur_health - amount)
	print("Took damage, current hp: ", cur_health)
	if cur_health == 0:
		print("Your Dead")

func heal(amount: int):
	cur_health = min(max_health, cur_health + amount)
