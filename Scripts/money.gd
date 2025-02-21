extends Area2D


func _on_body_entered(body: Node2D) -> void:
	PlayerGlobal.player_score += randi_range(7,12)
	queue_free()
