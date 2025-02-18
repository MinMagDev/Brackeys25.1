extends Enemy

var seen_player: bool
var player_in_attack_range: bool
var attack_ready: bool

var player : Node2D

var next_dest : Vector2

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	set_next_dest()
	
func set_next_dest():
	var dir = Vector2(randi() - randi(), randi() - randi())
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

func enemy_attack():
	if attack_ready and player_in_attack_range:
		attack_ready = false
		$AttackTimer.start()
		attack_player(damage)

func _on_sea_area_body_entered(body: Node2D) -> void:
	if body == player:
		seen_player = true
	


func _on_sea_area_body_exited(body: Node2D) -> void:
	if body == player:
		seen_player = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body == player:
		player_in_attack_range = true
		print("hello") 

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_attack_range = false
		print("bye")

# Attack Timer
func _on_timer_timeout() -> void:
	attack_ready = true


func _on_direction_timer_timeout() -> void:
	set_next_dest()
