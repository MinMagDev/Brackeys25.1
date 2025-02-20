extends Node2D

var dungeon_room_scn : PackedScene = preload("res://scenes/dungeon.tscn")

func _on_player_shoot_bullet(start_position: Vector2, direction: Vector2) -> void:
	var projectile = Projectile.new_projectile(start_position, direction)
	$Projectiles.add_child(projectile)

func _ready() -> void:
	#print(str(DungeonGlobal.generate_dungeon(5).size()))
	var dungeon = DungeonGlobal.generate_dungeon(7)
	#DungeonGlobal.print_dungeon(dungeon)
	place_generated_dungeon(dungeon)

func place_generated_dungeon(dungeon: Array[DungeonGlobal.DungeonRoom]) -> void:
	for room in dungeon:
		var room_node = dungeon_room_scn.instantiate()
		var room_position = Vector2(room.coordinate.y * 1200, room.coordinate.x * 700)
		room_node.room = room
		room_node.position = room_position
		$Rooms.add_child(room_node)
