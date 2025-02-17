extends Area2D


var is_open : bool = false

func set_is_open(value: bool) -> void:
	is_open = value
	$UpClosedDoor.visible = is_open
	

func _on_body_entered(body: Node2D) -> void:
	set_is_open(not is_open)
