extends Node

var max_health : int = 20
var cur_health : int = 20

var player_score : int = 0
var high_score : int = 0

func damage(amount: int):
	var damage = amount + ArtifactGlobal.taken_damage_buff
	cur_health = max(0, cur_health - damage)
	player_score -= damage
	print("Took damage, current hp: "+  str(cur_health) + "And current score : ", player_score)
	if cur_health == 0:
		print("You are Dead")
		back_to_main()

func heal(amount: int):
	cur_health = min(max_health, cur_health + amount)
	player_score += amount

func back_to_main() -> void:
	# Queue the current scene to free on the next frame:
	var root_node = get_tree().get_root()
	var scene_node = root_node.get_node("Main")
	scene_node.queue_free()

	# Load in some scene from our project files:
	var new_scene_resource = load("res://scenes/ui/main_menu.tscn") # Load the new level from disk
	var new_scene_node = new_scene_resource.instantiate() # Create an actual node of it for the game to use
	root_node.add_child(new_scene_node) # Add to the tree so the level starts processing
