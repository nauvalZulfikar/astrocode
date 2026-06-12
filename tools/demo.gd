## Live gameplay demo reel — runs in normal main loop (autoloads) + windowed (renders).
## Drives the core loop and screenshots each beat. Run:
##   Godot --path . res://tools/demo.tscn
extends Node

const SHOT_DIR := "/tmp/astro_shots/"

func _ready() -> void:
	var world: Node = load("res://scenes/world/main_world.tscn").instantiate()
	add_child(world)
	await _frames(8)
	await _shot("demo_01_spawn")

	# Move east.
	await _drive("move_right", 45)
	await _shot("demo_02_move_east")

	# Move south.
	await _drive("move_down", 45)
	await _shot("demo_03_move_south")

	# Spawn a robot next to the player and run a script on it.
	var player: Node2D = world.get_node("Player")
	var robot: Node2D = load("res://scenes/robots/robot_base.tscn").instantiate() as Node2D
	world.add_child(robot)
	robot.global_position = player.global_position + Vector2(20, 0)
	if robot.status == "shutdown" and robot.has_method("boot_up"):
		robot.boot_up()
	await _frames(4)
	var res: Dictionary = AstroScript.new().execute("robot.move(\"right\")", {"robot": robot})
	print("DEMO robot.move errors=%s status=%s" % [res.get("errors", []), robot.status])
	await _frames(30)  # let it physically move
	await _shot("demo_04_robot_running")

	# Open the code editor with sample code.
	var editor: Node = world.get_node("CodeEditor")
	if editor.has_method("open"):
		editor.open()
		if "code_input" in editor and editor.code_input:
			editor.code_input.text = "# program the gatherer robot\nprint(\"booting Scuttle...\")\nrobot.move(\"right\")\nrobot.move(\"down\")\nprint(\"done\")"
	await _frames(12)
	await _shot("demo_05_code_editor")

	print("DEMO_DONE")
	get_tree().quit(0)


func _drive(action: String, frames: int) -> void:
	Input.action_press(action)
	await _physics(frames)
	Input.action_release(action)
	await _frames(2)


func _frames(n: int) -> void:
	for i in range(n):
		await get_tree().process_frame


func _physics(n: int) -> void:
	for i in range(n):
		await get_tree().physics_frame


func _shot(name: String) -> void:
	await get_tree().process_frame
	var img: Image = get_viewport().get_texture().get_image()
	img.save_png(SHOT_DIR + name + ".png")
	print("SHOT %s" % name)
