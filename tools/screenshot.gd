## Headless-friendly screenshot tool.
## Usage: Godot --path . -s tools/screenshot.gd -- <scene_path> <out_png> [frames]
## Boots the given scene, waits N frames for layout/_ready, saves a viewport PNG, quits.
extends SceneTree

func _initialize() -> void:
	var raw_args: PackedStringArray = OS.get_cmdline_user_args()
	var scene_path: String = raw_args[0] if raw_args.size() > 0 else "res://scenes/world/main_world.tscn"
	var out_path: String = raw_args[1] if raw_args.size() > 1 else "user://shot.png"
	var frames: int = int(raw_args[2]) if raw_args.size() > 2 else 20

	var packed: PackedScene = load(scene_path)
	if packed == null:
		push_error("Could not load scene: %s" % scene_path)
		quit(1)
		return
	var inst: Node = packed.instantiate()
	root.add_child(inst)

	await _wait_frames(frames)

	var img: Image = root.get_viewport().get_texture().get_image()
	var err: int = img.save_png(out_path)
	if err != OK:
		push_error("save_png failed: %d" % err)
		quit(1)
		return
	print("SCREENSHOT_OK %s (%dx%d)" % [out_path, img.get_width(), img.get_height()])
	quit(0)


func _wait_frames(n: int) -> void:
	for i in range(n):
		await process_frame
