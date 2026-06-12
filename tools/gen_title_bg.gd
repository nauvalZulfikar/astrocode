extends SceneTree
func _initialize() -> void:
	var W := 320; var H := 180
	var img := Image.create(W, H, false, Image.FORMAT_RGBA8)
	var rng := RandomNumberGenerator.new(); rng.seed = 7
	var top := Color(0.03, 0.03, 0.07)
	var horizon := Color(0.55, 0.26, 0.12)
	var ground := Color(0.10, 0.09, 0.11)
	for y in range(H):
		var t := float(y) / H
		var c: Color
		if t < 0.60:
			c = top.lerp(horizon, pow(t / 0.60, 2.2))
		elif t < 0.63:
			c = Color(0.85, 0.45, 0.2)  # horizon glow line
		else:
			c = ground
		for x in range(W):
			img.set_pixel(x, y, c)
	# Stars in the upper sky.
	for i in range(90):
		var x := rng.randi() % W
		var y := rng.randi() % int(H * 0.5)
		var b := rng.randf_range(0.4, 1.0)
		img.set_pixel(x, y, Color(0.9, 0.9, 1.0, b))
	# A faint crashed-ship silhouette on the horizon.
	for x in range(W * 55 / 100, W * 68 / 100):
		for y in range(H * 56 / 100, H * 63 / 100):
			img.set_pixel(x, y, Color(0.06, 0.05, 0.07))
	img.save_png("/Users/shaka-mac-mini/coding-projects/astrocode/assets/ui/title_bg.png")
	print("TITLE_BG_OK")
	quit(0)
