extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if PlayerGlobal.player_score > PlayerGlobal.high_score:
		PlayerGlobal.high_score = PlayerGlobal.player_score
	
	# Queue the current scene to free on the next frame:
	var root_node = get_tree().get_root()
	var scene_node = root_node.get_node("Main")
	scene_node.queue_free()

	# Load in some scene from our project files:
	var new_scene_resource = load("res://scenes/ui/main_menu.tscn") # Load the new level from disk
	var new_scene_node = new_scene_resource.instantiate() # Create an actual node of it for the game to use
	root_node.add_child(new_scene_node) # Add to the tree so the level starts processing
