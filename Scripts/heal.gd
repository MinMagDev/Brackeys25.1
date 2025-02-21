extends Area2D


func _on_body_entered(body: Node2D) -> void:
	PlayerGlobal.heal(randi_range(3,7))
	queue_free()
