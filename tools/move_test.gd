## Phase C: prove the player physically moves when input is applied.
extends Node

func _ready() -> void:
	var world: Node = load("res://scenes/world/main_world.tscn").instantiate()
	add_child(world)
	await get_tree().process_frame
	await get_tree().process_frame

	var players: Array = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		print("FAIL: no player in scene"); get_tree().quit(1); return
	var player: Node2D = players[0]
	var start: Vector2 = player.global_position

	# Inject rightward movement for ~30 physics frames.
	Input.action_press("move_right")
	for i in range(30):
		await get_tree().physics_frame
	Input.action_release("move_right")

	var moved: Vector2 = player.global_position - start
	print("MOVE start=%s end=%s delta=%s facing=%s" % [start, player.global_position, moved, player._facing])
	var ok: bool = moved.x > 1.0
	print("MOVE RESULT %s" % ("PASS" if ok else "FAIL"))
	get_tree().quit(0 if ok else 1)
