extends Enemy

var seen_player
var player : Node2D

var next_dest : Vector2

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	set_next_dest()
	
func set_next_dest():
	var dir = Vector2(randi() - randi(), randi() - randi()).normalized() * 40
	next_dest = global_position + dir

func enemy_move(delta: float):
	var dir = Vector2.ZERO
	if seen_player:
		dir = player.global_position - global_position
	else:
		if abs(global_position.x - next_dest.x) < 5 or abs(global_position.y - next_dest.y) < 5:
			set_next_dest()
		dir = next_dest - global_position
	dir = dir.normalized()
	dir *= speed * delta
	move_and_collide(dir)


func _on_sea_area_body_entered(body: Node2D) -> void:
	if body == player:
		seen_player = true
		print("hello")
	


func _on_sea_area_body_exited(body: Node2D) -> void:
	if body == player:
		seen_player = false
		print("bye")
