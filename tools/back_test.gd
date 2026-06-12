extends Node
func _ready() -> void:
	var world: Node = load("res://scenes/world/main_world.tscn").instantiate()
	add_child(world)
	for i in range(8): await get_tree().process_frame
	var pause: Node = world.get_node("PauseMenu")
	var fails := 0
	var cases := [
		["CraftingPanel", "open"],   # opened via E at workbench -> the reported bug
		["InventoryPanel", "toggle"],
		["SableTerminal", "toggle"],
		["QuestJournal", "toggle"],
	]
	for c in cases:
		var p: Node = world.get_node(c[0])
		if c[1] == "open": p.open(0)
		else: p.toggle()
		await get_tree().process_frame
		var opened: bool = p.is_open
		# Inject Escape (the "pause" action)
		var ev := InputEventAction.new(); ev.action = "pause"; ev.pressed = true
		Input.parse_input_event(ev)
		await get_tree().process_frame
		await get_tree().process_frame
		var closed: bool = not p.is_open
		var pause_stacked: bool = pause.is_open
		var ok: bool = opened and closed and not pause_stacked
		print("%s: opened=%s closed_on_esc=%s pause_stacked=%s -> %s" % [c[0], opened, closed, pause_stacked, "OK" if ok else "FAIL"])
		if not ok: fails += 1
		if pause.is_open: pause.close()
	# Bonus: Esc with nothing open should open pause
	var ev2 := InputEventAction.new(); ev2.action = "pause"; ev2.pressed = true
	Input.parse_input_event(ev2)
	await get_tree().process_frame
	await get_tree().process_frame
	print("Esc-with-nothing-open opens pause: %s" % ("OK" if pause.is_open else "FAIL"))
	if not pause.is_open: fails += 1
	print("BACK RESULT %d/5 passed" % (5 - fails))
	get_tree().quit(0 if fails == 0 else 1)
