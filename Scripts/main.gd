extends Node2D

func _on_player_shoot_bullet(start_position: Vector2, direction: Vector2) -> void:
	var projectile = Projectile.new_projectile(start_position, direction)
	$Projectiles.add_child(projectile)
