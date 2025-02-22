extends Control

var points_label : String = "Points: "
var health_label : String = "Health: "

#TODO: Main Menu
#TODO: Win and Lose Screen
func _process(_delta: float) -> void:
	$VBoxContainer/Points.text = points_label + str(PlayerGlobal.player_score)
	$VBoxContainer/Health.text = health_label + str(PlayerGlobal.cur_health) + " / " + str(PlayerGlobal.max_health)
