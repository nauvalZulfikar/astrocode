## Runtime test: player 8-direction sprite mapping.
extends SceneTree

func _initialize() -> void:
	var packed: PackedScene = load("res://scenes/player/player.tscn")
	var p: Node = packed.instantiate()
	root.add_child(p)
	await process_frame

	var cases: Array = [
		[Vector2(1, 0), "east"],
		[Vector2(1, 1), "south-east"],
		[Vector2(0, 1), "south"],
		[Vector2(-1, 1), "south-west"],
		[Vector2(-1, 0), "west"],
		[Vector2(-1, -1), "north-west"],
		[Vector2(0, -1), "north"],
		[Vector2(1, -1), "north-east"],
	]
	var fails: int = 0
	for c in cases:
		p._update_facing(c[0])
		var got: String = p._facing
		var tex_ok: bool = p.sprite.texture == p.DIR_TEXTURES[c[1]]
		if got != c[1] or not tex_ok:
			print("FAIL %s -> got '%s' tex_ok=%s (want '%s')" % [c[0], got, tex_ok, c[1]])
			fails += 1
		else:
			print("ok   %s -> %s" % [c[0], got])
	print("RESULT %d/%d passed" % [cases.size() - fails, cases.size()])
	quit(1 if fails > 0 else 0)
