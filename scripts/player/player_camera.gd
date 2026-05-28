## PlayerCamera — Smooth-follow Camera2D attached to the player.
extends Camera2D

## World bounds (in pixels). The camera will not scroll past these.
@export var limit_left_bound: int = -1000
@export var limit_top_bound: int = -1000
@export var limit_right_bound: int = 1000
@export var limit_bottom_bound: int = 1000


func _ready() -> void:
	# Smooth follow.
	position_smoothing_enabled = true
	position_smoothing_speed = 8.0

	# 1:1 zoom for 320x180 viewport.
	zoom = Vector2(1, 1)

	# Set camera limits.
	limit_left = limit_left_bound
	limit_top = limit_top_bound
	limit_right = limit_right_bound
	limit_bottom = limit_bottom_bound

	# Make this the current camera.
	make_current()
