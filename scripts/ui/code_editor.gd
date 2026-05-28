## CodeEditor — Full-screen code editor overlay for writing AstroScript programs.
## Opens when interacting with a Base Terminal. Integrates with the AstroScript
## interpreter and robot system.
extends CanvasLayer

# --- Signals ---
signal editor_opened()
signal editor_closed()
signal script_executed(result: Dictionary)

# --- Node references ---
@onready var panel: PanelContainer = $Panel
@onready var code_input: TextEdit = $Panel/MainMargin/VBox/ContentSplit/LeftPanel/CodeInput
@onready var output_log: RichTextLabel = $Panel/MainMargin/VBox/ContentSplit/RightPanel/OutputScroll/OutputLog
@onready var robot_selector: OptionButton = $Panel/MainMargin/VBox/BottomBar/RobotSelector
@onready var run_button: Button = $Panel/MainMargin/VBox/BottomBar/RunButton
@onready var stop_button: Button = $Panel/MainMargin/VBox/BottomBar/StopButton
@onready var close_button: Button = $Panel/MainMargin/VBox/BottomBar/CloseButton
@onready var script_name_edit: LineEdit = $Panel/MainMargin/VBox/TopBar/ScriptName
@onready var save_button: Button = $Panel/MainMargin/VBox/TopBar/SaveButton
@onready var load_button: Button = $Panel/MainMargin/VBox/TopBar/LoadButton
@onready var load_popup: PopupMenu = $LoadPopup

# --- State ---
var is_open: bool = false
var _interpreter: AstroScript = null
var _selected_robot: Node2D = null
var _was_time_paused: bool = false


func _ready() -> void:
	panel.visible = false
	is_open = false
	_interpreter = AstroScript.new()

	# Connect buttons.
	run_button.pressed.connect(_on_run_pressed)
	stop_button.pressed.connect(_on_stop_pressed)
	close_button.pressed.connect(close)
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	robot_selector.item_selected.connect(_on_robot_selected)
	load_popup.id_pressed.connect(_on_load_item_selected)

	# Configure code input.
	code_input.placeholder_text = "# Write AstroScript here...\nprint(\"Hello, Thyra-7!\")"

	# Add to group for lookup.
	add_to_group("code_editor")


func _unhandled_input(event: InputEvent) -> void:
	if is_open and event is InputEventKey:
		var key_event: InputEventKey = event as InputEventKey
		if key_event.pressed and key_event.keycode == KEY_ESCAPE:
			close()
			get_viewport().set_input_as_handled()


## Open the code editor.
func open() -> void:
	if is_open:
		return

	is_open = true
	panel.visible = true

	# Auto-pause game (per game-design.md: auto-pause on code editor = ON).
	_was_time_paused = TimeManager.paused
	TimeManager.paused = true

	# Populate robot selector.
	_refresh_robot_selector()

	# Clear output.
	output_log.clear()
	output_log.push_color(Color(0.7, 0.7, 0.7))
	output_log.add_text("> Ready. Select a robot and press RUN.\n")
	output_log.pop()

	# Focus the code input.
	code_input.grab_focus()

	editor_opened.emit()


## Close the code editor.
func close() -> void:
	if not is_open:
		return

	is_open = false
	panel.visible = false

	# Restore time pause state.
	if not _was_time_paused:
		TimeManager.paused = false

	editor_closed.emit()


## Refresh the robot dropdown with currently active robots.
func _refresh_robot_selector() -> void:
	robot_selector.clear()
	robot_selector.add_item("-- Select Robot --", 0)

	var robots: Array = RobotManager.get_all_robots()
	for i: int in range(robots.size()):
		var robot: Node2D = robots[i] as Node2D
		if is_instance_valid(robot):
			var display: String = "%s (%s)" % [robot.robot_name, robot.robot_type]
			robot_selector.add_item(display, i + 1)

	_selected_robot = null


## Handle robot selection from dropdown.
func _on_robot_selected(index: int) -> void:
	if index <= 0:
		_selected_robot = null
		return

	var robots: Array = RobotManager.get_all_robots()
	var robot_index: int = index - 1  # Offset by 1 for the "-- Select --" entry.
	if robot_index >= 0 and robot_index < robots.size():
		_selected_robot = robots[robot_index] as Node2D
	else:
		_selected_robot = null


## Execute the code in the editor.
func _on_run_pressed() -> void:
	var source: String = code_input.text
	if source.strip_edges() == "":
		_append_output("Nothing to run.", Color(0.7, 0.7, 0.7))
		return

	# Build execution context.
	var context: Dictionary = {}
	if _selected_robot and is_instance_valid(_selected_robot):
		context["robot"] = _selected_robot

	# Clear previous output.
	output_log.clear()
	_append_output("> Running script...\n", Color(0.4, 0.8, 0.6))

	# Execute.
	var interpreter: AstroScript = AstroScript.new()
	var result: Dictionary = interpreter.execute(source, context)

	# Display output.
	var output_lines: Array = result.get("output", [])
	for line: Variant in output_lines:
		_append_output(str(line), Color(0.85, 0.85, 0.85))

	# Display errors.
	var error_lines: Array = result.get("errors", [])
	for line: Variant in error_lines:
		_append_output("ERROR: " + str(line), Color(0.95, 0.3, 0.3))

	# Summary.
	if error_lines.is_empty():
		_append_output("\n> Execution complete.", Color(0.4, 0.8, 0.6))
	else:
		_append_output("\n> Execution finished with %d error(s)." % error_lines.size(), Color(0.95, 0.5, 0.3))

	# Display variable state.
	var variables: Dictionary = result.get("variables", {})
	if not variables.is_empty():
		_append_output("\n--- Variables ---", Color(0.5, 0.5, 0.5))
		for key: String in variables:
			_append_output("  %s = %s" % [key, str(variables[key])], Color(0.5, 0.7, 0.5))

	script_executed.emit(result)


## Stop execution (for future async execution support).
func _on_stop_pressed() -> void:
	_append_output("> Execution stopped.", Color(0.95, 0.5, 0.3))


## Save the current script.
func _on_save_pressed() -> void:
	var name: String = script_name_edit.text.strip_edges()
	if name == "":
		_append_output("ERROR: Enter a script name before saving.", Color(0.95, 0.3, 0.3))
		return

	var source: String = code_input.text
	GameManager.save_script(name, source)
	_append_output("> Script '%s' saved." % name, Color(0.4, 0.8, 0.6))


## Open the load popup with saved script names.
func _on_load_pressed() -> void:
	load_popup.clear()
	var scripts: Array[String] = GameManager.get_script_list()
	if scripts.is_empty():
		load_popup.add_item("(no saved scripts)", 0)
		load_popup.set_item_disabled(0, true)
	else:
		for i: int in range(scripts.size()):
			load_popup.add_item(scripts[i], i)

	# Position popup near the load button.
	var button_rect: Rect2 = load_button.get_global_rect()
	load_popup.position = Vector2i(int(button_rect.position.x), int(button_rect.end.y))
	load_popup.popup()


## Handle selecting a script from the load popup.
func _on_load_item_selected(id: int) -> void:
	var scripts: Array[String] = GameManager.get_script_list()
	if id >= 0 and id < scripts.size():
		var name: String = scripts[id]
		var source: String = GameManager.load_script(name)
		code_input.text = source
		script_name_edit.text = name
		_append_output("> Script '%s' loaded." % name, Color(0.4, 0.8, 0.6))


## Append colored text to the output log.
func _append_output(text: String, color: Color = Color(0.85, 0.85, 0.85)) -> void:
	output_log.push_color(color)
	output_log.add_text(text + "\n")
	output_log.pop()
