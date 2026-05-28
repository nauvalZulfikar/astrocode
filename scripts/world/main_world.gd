## MainWorld — Test world scene controller.
## Manages day/night lighting and spawns initial resource nodes.
extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var player: CharacterBody2D = $Player

# Day/night color ramp.
const DAY_COLOR: Color = Color(1.0, 1.0, 1.0)           # Full brightness
const DUSK_COLOR: Color = Color(0.85, 0.65, 0.5)         # Warm sunset
const NIGHT_COLOR: Color = Color(0.25, 0.25, 0.45)       # Dark blue
const DAWN_COLOR: Color = Color(0.75, 0.65, 0.6)         # Soft morning

# Resource spawn definitions for the test world.
const RESOURCE_SPAWNS: Array = [
	{"id": "scrap_metal", "pos": Vector2(60, 30), "count": 3},
	{"id": "scrap_metal", "pos": Vector2(-40, -50), "count": 2},
	{"id": "scrap_metal", "pos": Vector2(100, -20), "count": 4},
	{"id": "copper_wire", "pos": Vector2(-70, 60), "count": 5},
	{"id": "copper_wire", "pos": Vector2(30, -80), "count": 3},
	{"id": "salt_crystal", "pos": Vector2(-90, -30), "count": 2},
	{"id": "salt_crystal", "pos": Vector2(80, 70), "count": 3},
	{"id": "iron_ore", "pos": Vector2(-120, 40), "count": 2},
	{"id": "biomass", "pos": Vector2(50, 80), "count": 4},
	{"id": "silicon", "pos": Vector2(-60, -90), "count": 1},
]

var _resource_scene: PackedScene = preload("res://scenes/resources/resource_node.tscn")

# Robot panel reference (set in _ready from the scene tree).
@onready var robot_panel: CanvasLayer = $RobotPanel

# UI panel references.
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var save_load_panel: CanvasLayer = $SaveLoadPanel


func _ready() -> void:
	# Connect time signals for day/night lighting.
	TimeManager.hour_changed.connect(_on_hour_changed)
	TimeManager.night_started.connect(_on_night_started)
	TimeManager.day_started.connect(_on_day_started)

	# Connect player interaction to robot panel.
	player.interacted_with.connect(_on_player_interacted)

	# Connect pause menu to save/load panel.
	pause_menu.save_requested.connect(_on_save_requested)
	pause_menu.load_requested.connect(_on_load_requested)
	save_load_panel.closed.connect(_on_save_load_closed)

	# Initial lighting.
	_update_lighting()

	# Spawn resource nodes.
	_spawn_resources()

	# Spawn a test Scuttle robot for immediate testing.
	_spawn_test_robot()


func _process(_delta: float) -> void:
	# Continuously update lighting for smooth transitions.
	_update_lighting()


## Spawn resource nodes from the RESOURCE_SPAWNS table.
func _spawn_resources() -> void:
	for spawn_data in RESOURCE_SPAWNS:
		var node: Node2D = _resource_scene.instantiate()
		node.resource_id = spawn_data["id"]
		node.resource_count = spawn_data["count"]
		node.position = spawn_data["pos"]
		add_child(node)


## Update the CanvasModulate color based on current time of day.
func _update_lighting() -> void:
	var progress: float = TimeManager.get_day_progress()

	# Map progress to a color:
	# 0.0 (hour 0) = dawn, 0.3 (hour ~4) = full day, 0.6 (hour ~8) = dusk,
	# 0.64 (hour 9) = night start, 1.0 (hour 14) = near dawn again.
	var color: Color
	if progress < 0.07:
		# Dawn transition (hour 0-1).
		color = DAWN_COLOR.lerp(DAY_COLOR, progress / 0.07)
	elif progress < 0.57:
		# Full daytime (hours 1-8).
		color = DAY_COLOR
	elif progress < 0.64:
		# Dusk transition (hour 8-9).
		var t: float = (progress - 0.57) / 0.07
		color = DAY_COLOR.lerp(DUSK_COLOR, t)
	elif progress < 0.71:
		# Dusk to night (hour 9-10).
		var t: float = (progress - 0.64) / 0.07
		color = DUSK_COLOR.lerp(NIGHT_COLOR, t)
	else:
		# Night (hours 10-13).
		# Slight brightening near end of night (approaching dawn).
		if progress > 0.93:
			var t: float = (progress - 0.93) / 0.07
			color = NIGHT_COLOR.lerp(DAWN_COLOR, t)
		else:
			color = NIGHT_COLOR

	canvas_modulate.color = color


func _on_hour_changed(hour: int) -> void:
	pass  # Lighting is handled in _process for smooth transitions.


func _on_night_started() -> void:
	pass  # Could trigger night-specific events here.


func _on_day_started() -> void:
	pass  # Could trigger dawn events here.


## Handle player interaction — robots open the robot panel, NPCs trigger dialogue,
## BaseTerminal opens the code editor, CircuitWorkbench opens the circuit builder.
func _on_player_interacted(body: Node2D) -> void:
	if body is NPCBase:
		body.interact()
		return
	if body is RobotBase:
		robot_panel.open(body)
		return
	if body is BaseTerminal:
		body.start_gather(player)
		return
	if body is CircuitWorkbench:
		body.start_gather(player)
		return


## Spawn a test Scuttle robot at (40, 40) for immediate testing.
func _spawn_test_robot() -> void:
	var robot_scene: PackedScene = preload("res://scenes/robots/robot_base.tscn")
	var robot: Node2D = robot_scene.instantiate()
	robot.set_script(preload("res://scripts/robots/robot_scuttle.gd"))
	robot.robot_type = "scuttle"
	robot.robot_name = "Scuttle"
	robot.battery_max = 45.0
	robot.battery_current = 45.0
	robot.max_cargo = 6
	robot.move_speed = 40.0
	robot.position = Vector2(40, 40)
	add_child(robot)

	# Track it in RobotManager.
	RobotManager.active_robots.append(robot)
	robot.tree_exiting.connect(func() -> void:
		RobotManager.active_robots.erase(robot)
		RobotManager.robot_destroyed.emit(robot)
	)
	RobotManager.robot_built.emit(robot)

	# Tag scrap_metal for auto-harvest so testers can see the feature.
	if robot.has_method("tag_resource"):
		robot.tag_resource("scrap_metal")


## Open the save/load panel in save mode (from pause menu).
func _on_save_requested() -> void:
	pause_menu.panel.visible = false
	save_load_panel.open("save")


## Open the save/load panel in load mode (from pause menu).
func _on_load_requested() -> void:
	pause_menu.panel.visible = false
	save_load_panel.open("load")


## When the save/load panel closes, re-show the pause menu.
func _on_save_load_closed() -> void:
	pause_menu.panel.visible = true
