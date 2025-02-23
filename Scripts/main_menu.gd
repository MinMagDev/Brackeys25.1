extends Control

func _ready() -> void:
	$Menu/VBoxContainer/highscore.text = "Highscore: " + str(PlayerGlobal.high_score)
	
func _on_credits_button_pressed() -> void:
	$Credits.visible = true
	$Menu.visible = false

func _on_back_button_pressed() -> void:
	$Intro.visible = false
	$Credits.visible = false
	$Menu.visible = true


func _on_play_button_pressed() -> void:
	
	#Reset game
	PlayerGlobal.cur_health = PlayerGlobal.max_health
	PlayerGlobal.player_score = 0
	DungeonGlobal.current_dungeon = []
	DungeonGlobal.in_rooms_doors = [Vector2(-42, -42)]
	ArtifactGlobal.reset()
	
	
	# Queue the current scene to free on the next frame:
	var root_node = get_tree().get_root()
	var scene_node = root_node.get_node("MainMenu")
	scene_node.queue_free()

	# Load in some scene from our project files:
	var new_scene_resource = load("res://scenes/main.tscn") # Load the new level from disk
	var new_scene_node = new_scene_resource.instantiate() # Create an actual node of it for the game to use
	root_node.add_child(new_scene_node) # Add to the tree so the level starts processing


func _on_intro_pressed() -> void:
	$Intro.visible = true
	$Menu.visible = false
