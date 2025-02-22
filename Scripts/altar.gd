extends Area2D

signal start()

func _on_body_entered(body: Node2D) -> void:
	start.emit()
	$ArtifactSprite.visible = false
