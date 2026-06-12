extends Node
func _ready() -> void:
	var title: Node = load("res://scenes/ui/title_screen.tscn").instantiate()
	add_child(title)
	await get_tree().process_frame
	var fails := 0
	# New Game button wired?
	if title.new_game_btn.pressed.get_connections().is_empty():
		print("FAIL: New Game not connected"); fails += 1
	# Quit wired?
	if title.quit_btn.pressed.get_connections().is_empty():
		print("FAIL: Quit not connected"); fails += 1
	# Transition target valid + instantiable?
	if not ResourceLoader.exists("res://scenes/world/main_world.tscn"):
		print("FAIL: world scene missing"); fails += 1
	else:
		var w: Node = load("res://scenes/world/main_world.tscn").instantiate()
		if w == null: print("FAIL: world won't instantiate"); fails += 1
		else: w.queue_free()
	# Background loader picked up title_bg?
	if not title.bg_texture.visible:
		print("FAIL: title_bg not loaded"); fails += 1
	print("TITLE RESULT %d/4 passed" % (4 - fails))
	get_tree().quit(0 if fails == 0 else 1)
