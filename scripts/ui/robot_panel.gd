## RobotPanel — Interaction panel for inspecting and commanding a robot.
## Opens when the player presses E near a robot. Shows status, battery, cargo, and commands.
extends CanvasLayer

# --- Node references ---
@onready var panel: PanelContainer = $Panel
@onready var name_label: Label = $Panel/MarginContainer/VBox/NameLabel
@onready var type_label: Label = $Panel/MarginContainer/VBox/TypeLabel
@onready var battery_bar: ProgressBar = $Panel/MarginContainer/VBox/BatteryBar
@onready var status_label: Label = $Panel/MarginContainer/VBox/StatusLabel
@onready var cargo_label: Label = $Panel/MarginContainer/VBox/CargoLabel
@onready var task_label: Label = $Panel/MarginContainer/VBox/TaskLabel
@onready var btn_go_here: Button = $Panel/MarginContainer/VBox/ButtonRow/BtnGoHere
@onready var btn_gather: Button = $Panel/MarginContainer/VBox/ButtonRow/BtnGather
@onready var btn_return: Button = $Panel/MarginContainer/VBox/ButtonRow/BtnReturn
@onready var btn_shutdown: Button = $Panel/MarginContainer/VBox/ButtonRow2/BtnShutdown
@onready var btn_close: Button = $Panel/MarginContainer/VBox/ButtonRow2/BtnClose

# --- State ---
var is_open: bool = false
var target_robot: Node2D = null
var _player: Node2D = null

# Set to true while waiting for the player to click a move target.
var _awaiting_move_click: bool = false


func _ready() -> void:
	panel.visible = false
	is_open = false

	# Connect buttons.
	btn_go_here.pressed.connect(_on_go_here_pressed)
	btn_gather.pressed.connect(_on_gather_pressed)
	btn_return.pressed.connect(_on_return_pressed)
	btn_shutdown.pressed.connect(_on_shutdown_pressed)
	btn_close.pressed.connect(close)


func _process(_delta: float) -> void:
	if is_open and target_robot and is_instance_valid(target_robot):
		_refresh_panel()


func _unhandled_input(event: InputEvent) -> void:
	# Close panel with E or Escape.
	if is_open and event is InputEventKey:
		var key_event: InputEventKey = event as InputEventKey
		if key_event.pressed and not key_event.echo:
			if key_event.physical_keycode == KEY_ESCAPE:
				close()
				get_viewport().set_input_as_handled()

	# Handle move target click.
	if _awaiting_move_click and event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			_set_move_target(mouse_event.global_position)
			get_viewport().set_input_as_handled()


## Open the panel for a specific robot.
func open(robot: Node2D) -> void:
	if not robot or not is_instance_valid(robot):
		return
	target_robot = robot
	is_open = true
	panel.visible = true
	_refresh_panel()


## Close the panel.
func close() -> void:
	is_open = false
	panel.visible = false
	target_robot = null
	_awaiting_move_click = false


## Refresh all panel data from the target robot.
func _refresh_panel() -> void:
	if target_robot == null or not is_instance_valid(target_robot):
		close()
		return

	var info: Dictionary = target_robot.get_status()

	name_label.text = info.get("robot_name", "Robot")
	type_label.text = "Type: %s" % info.get("robot_type", "unknown")

	battery_bar.max_value = info.get("battery_max", 45.0)
	battery_bar.value = info.get("battery", 0.0)

	status_label.text = "Status: %s" % info.get("status", "idle")

	# Cargo display.
	var cargo_count: int = info.get("cargo_count", 0)
	var max_c: int = info.get("max_cargo", 0)
	var cargo_items: Array = info.get("cargo", [])
	var cargo_text: String = "Cargo: %d/%d" % [cargo_count, max_c]
	if not cargo_items.is_empty():
		var item_strs: PackedStringArray = PackedStringArray()
		for item: Dictionary in cargo_items:
			var item_name: String = InventoryManager.get_item_name(item["id"])
			item_strs.append("%s x%d" % [item_name, item["count"]])
		cargo_text += "\n  " + ", ".join(item_strs)
	cargo_label.text = cargo_text

	# Task display.
	var tasks: int = info.get("task_queue_size", 0)
	task_label.text = "Tasks queued: %d" % tasks

	# Update shutdown button text.
	var robot_status: String = info.get("status", "idle")
	if robot_status == "shutdown":
		btn_shutdown.text = "Boot Up"
	else:
		btn_shutdown.text = "Shutdown"


## Button handlers.
func _on_go_here_pressed() -> void:
	if target_robot and is_instance_valid(target_robot):
		# For now, send robot to the player's position.
		_player = get_tree().get_first_node_in_group("player")
		if _player:
			target_robot.move_to(_player.global_position)


func _on_gather_pressed() -> void:
	if target_robot and is_instance_valid(target_robot):
		# Gather the nearest resource.
		var nodes: Array[Node] = get_tree().get_nodes_in_group("resources")
		var closest: Node2D = null
		var closest_dist: float = INF
		for node: Node in nodes:
			var rnode: Node2D = node as Node2D
			if rnode and is_instance_valid(rnode):
				var dist: float = target_robot.global_position.distance_to(rnode.global_position)
				if dist < closest_dist:
					closest_dist = dist
					closest = rnode
		if closest:
			target_robot.gather(closest.resource_id)


func _on_return_pressed() -> void:
	if target_robot and is_instance_valid(target_robot):
		target_robot.deposit()


func _on_shutdown_pressed() -> void:
	if target_robot and is_instance_valid(target_robot):
		if target_robot.status == "shutdown":
			target_robot.boot_up()
		else:
			target_robot.shutdown()


func _set_move_target(screen_pos: Vector2) -> void:
	_awaiting_move_click = false
	if target_robot and is_instance_valid(target_robot):
		# Convert screen position to world position.
		var viewport: Viewport = get_viewport()
		var camera: Camera2D = viewport.get_camera_2d()
		if camera:
			var world_pos: Vector2 = camera.get_global_mouse_position()
			target_robot.move_to(world_pos)
