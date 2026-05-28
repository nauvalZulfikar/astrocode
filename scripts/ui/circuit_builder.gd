## CircuitBuilder — Full-screen overlay for building and simulating circuits.
## Opens when interacting with a CircuitWorkbench.
## Grid-based breadboard drawn via Control._draw().
extends CanvasLayer

# --- Signals ---
signal builder_opened()
signal builder_closed()

# --- Node references ---
@onready var panel: PanelContainer = $Panel
@onready var grid_area: Control = $Panel/MainMargin/VBox/ContentSplit/GridPanel/GridArea
@onready var palette_list: VBoxContainer = $Panel/MainMargin/VBox/ContentSplit/PalettePanel/PaletteScroll/PaletteList
@onready var simulate_button: Button = $Panel/MainMargin/VBox/BottomBar/SimulateButton
@onready var clear_button: Button = $Panel/MainMargin/VBox/BottomBar/ClearButton
@onready var close_button: Button = $Panel/MainMargin/VBox/BottomBar/CloseButton
@onready var status_label: Label = $Panel/MainMargin/VBox/BottomBar/StatusLabel

# --- State ---
var is_open: bool = false
var _circuit_id: int = -1
var _puzzle_id: String = ""
var _selected_component: String = ""
var _was_time_paused: bool = false
var _sim_result: Dictionary = {}

# Drawing state.
var _is_wire_dragging: bool = false
var _wire_start_col: int = -1
var _wire_start_row: int = -1

# Grid drawing constants — calculated in _ready based on grid_area size.
var _cell_size: float = 0.0
var _grid_origin: Vector2 = Vector2.ZERO

# Colors.
const COLOR_BG: Color = Color(0.12, 0.14, 0.12)
const COLOR_GRID_DOT: Color = Color(0.3, 0.35, 0.3)
const COLOR_RAIL_POS: Color = Color(0.8, 0.2, 0.2)
const COLOR_RAIL_NEG: Color = Color(0.2, 0.3, 0.8)
const COLOR_WIRE: Color = Color(0.85, 0.55, 0.2)
const COLOR_RESISTOR: Color = Color(0.75, 0.65, 0.45)
const COLOR_LED_RED_OFF: Color = Color(0.4, 0.15, 0.15)
const COLOR_LED_RED_ON: Color = Color(1.0, 0.2, 0.2)
const COLOR_LED_GREEN_OFF: Color = Color(0.15, 0.3, 0.15)
const COLOR_LED_GREEN_ON: Color = Color(0.2, 1.0, 0.3)
const COLOR_BATTERY: Color = Color(0.9, 0.85, 0.2)
const COLOR_SELECTED: Color = Color(0.3, 0.85, 0.5)
const COLOR_HOVER: Color = Color(0.5, 0.5, 0.6, 0.4)
const COLOR_BURNED: Color = Color(0.3, 0.1, 0.1)


func _ready() -> void:
	panel.visible = false
	is_open = false

	# Connect buttons.
	simulate_button.pressed.connect(_on_simulate_pressed)
	clear_button.pressed.connect(_on_clear_pressed)
	close_button.pressed.connect(close)

	# Connect grid input.
	grid_area.gui_input.connect(_on_grid_input)
	grid_area.draw.connect(_on_grid_draw)
	grid_area.mouse_filter = Control.MOUSE_FILTER_STOP

	# Add to group for lookup.
	add_to_group("circuit_builder")


func _unhandled_input(event: InputEvent) -> void:
	if is_open and event is InputEventKey:
		var key_event: InputEventKey = event as InputEventKey
		if key_event.pressed and key_event.keycode == KEY_ESCAPE:
			close()
			get_viewport().set_input_as_handled()


## Open the circuit builder, optionally with a puzzle context.
func open(puzzle_id: String = "") -> void:
	if is_open:
		return

	is_open = true
	_puzzle_id = puzzle_id
	panel.visible = true

	# Create a new circuit if we don't have one.
	if _circuit_id < 0:
		_circuit_id = CircuitManager.create_circuit()

	_sim_result = {}
	_selected_component = ""
	_is_wire_dragging = false

	# Auto-pause game.
	_was_time_paused = TimeManager.paused
	TimeManager.paused = true

	# Update cell size based on actual grid_area size.
	_recalculate_grid_layout()

	# Build palette.
	_rebuild_palette()

	# Set initial status.
	if puzzle_id != "":
		status_label.text = "Puzzle: %s — Place components, then SIMULATE" % puzzle_id
	else:
		status_label.text = "Place components, then SIMULATE"

	grid_area.queue_redraw()
	builder_opened.emit()


## Close the circuit builder.
func close() -> void:
	if not is_open:
		return

	is_open = false
	panel.visible = false
	_is_wire_dragging = false

	# Restore time pause state.
	if not _was_time_paused:
		TimeManager.paused = false

	builder_closed.emit()


## Recalculate grid drawing layout based on the grid_area control size.
func _recalculate_grid_layout() -> void:
	var area_size: Vector2 = grid_area.size
	if area_size.x <= 0.0 or area_size.y <= 0.0:
		# Fallback — will be recalculated on next draw.
		_cell_size = 10.0
		_grid_origin = Vector2(4.0, 4.0)
		return

	var margin: float = 4.0
	var usable: Vector2 = area_size - Vector2(margin * 2.0, margin * 2.0)
	var cell_w: float = usable.x / float(CircuitManager.GRID_COLS)
	var cell_h: float = usable.y / float(CircuitManager.GRID_ROWS)
	_cell_size = minf(cell_w, cell_h)

	# Center the grid.
	var grid_w: float = _cell_size * float(CircuitManager.GRID_COLS)
	var grid_h: float = _cell_size * float(CircuitManager.GRID_ROWS)
	_grid_origin = Vector2(
		margin + (usable.x - grid_w) * 0.5,
		margin + (usable.y - grid_h) * 0.5,
	)


## Get the center position of a grid cell in local coordinates.
func _cell_center(col: int, row: int) -> Vector2:
	return _grid_origin + Vector2(
		(float(col) + 0.5) * _cell_size,
		(float(row) + 0.5) * _cell_size,
	)


## Convert a local position to grid coordinates. Returns Vector2i(-1,-1) if out of bounds.
func _pos_to_cell(pos: Vector2) -> Vector2i:
	var local: Vector2 = pos - _grid_origin
	var col: int = int(local.x / _cell_size)
	var row: int = int(local.y / _cell_size)
	if col < 0 or col >= CircuitManager.GRID_COLS or row < 0 or row >= CircuitManager.GRID_ROWS:
		return Vector2i(-1, -1)
	return Vector2i(col, row)


# =============================================================================
# Grid drawing
# =============================================================================

## Custom draw callback for the grid area.
func _on_grid_draw() -> void:
	_recalculate_grid_layout()

	# Background.
	grid_area.draw_rect(Rect2(Vector2.ZERO, grid_area.size), COLOR_BG)

	# Power rail lines.
	var rail_y_pos: float = _grid_origin.y + _cell_size * 0.5
	var rail_y_neg: float = _grid_origin.y + (float(CircuitManager.GRID_ROWS) - 0.5) * _cell_size
	var rail_x_start: float = _grid_origin.x
	var rail_x_end: float = _grid_origin.x + float(CircuitManager.GRID_COLS) * _cell_size
	grid_area.draw_line(Vector2(rail_x_start, rail_y_pos), Vector2(rail_x_end, rail_y_pos), COLOR_RAIL_POS, 1.5)
	grid_area.draw_line(Vector2(rail_x_start, rail_y_neg), Vector2(rail_x_end, rail_y_neg), COLOR_RAIL_NEG, 1.5)

	# Rail labels.
	grid_area.draw_string(ThemeDB.fallback_font, Vector2(rail_x_start - 3.0, rail_y_pos + 1.5), "+", HORIZONTAL_ALIGNMENT_RIGHT, -1, 5, COLOR_RAIL_POS)
	grid_area.draw_string(ThemeDB.fallback_font, Vector2(rail_x_start - 3.0, rail_y_neg + 1.5), "-", HORIZONTAL_ALIGNMENT_RIGHT, -1, 5, COLOR_RAIL_NEG)

	# Grid dots.
	for r: int in range(CircuitManager.GRID_ROWS):
		for c: int in range(CircuitManager.GRID_COLS):
			var center: Vector2 = _cell_center(c, r)
			grid_area.draw_circle(center, 1.0, COLOR_GRID_DOT)

	# Draw wires.
	var wires: Array = CircuitManager.get_wires(_circuit_id)
	for w: Dictionary in wires:
		var from_pos: Vector2 = _cell_center(w["from_col"], w["from_row"])
		var to_pos: Vector2 = _cell_center(w["to_col"], w["to_row"])
		grid_area.draw_line(from_pos, to_pos, COLOR_WIRE, 1.5)

	# Draw components.
	var grid: Array = CircuitManager.get_grid(_circuit_id)
	var comp_states: Dictionary = _build_state_lookup()

	for r: int in range(CircuitManager.GRID_ROWS):
		for c: int in range(CircuitManager.GRID_COLS):
			var comp_type: String = grid[r][c]
			if comp_type == "":
				continue
			_draw_component(c, r, comp_type, comp_states)

	# Wire drag preview.
	if _is_wire_dragging and _wire_start_col >= 0:
		var start_pos: Vector2 = _cell_center(_wire_start_col, _wire_start_row)
		var mouse_pos: Vector2 = grid_area.get_local_mouse_position()
		grid_area.draw_line(start_pos, mouse_pos, Color(COLOR_WIRE, 0.5), 1.0)


## Draw a single component at grid position.
func _draw_component(col: int, row: int, comp_type: String, states: Dictionary) -> void:
	var center: Vector2 = _cell_center(col, row)
	var half: float = _cell_size * 0.35
	var state_key: String = "%d,%d" % [col, row]
	var is_burned: bool = false
	var is_lit: bool = false

	if states.has(state_key):
		is_burned = states[state_key].get("is_burned", false)
		is_lit = states[state_key].get("is_lit", false)

	if comp_type.begins_with("resistor_"):
		# Resistor: tan rectangle.
		var color: Color = COLOR_BURNED if is_burned else COLOR_RESISTOR
		var rect: Rect2 = Rect2(center - Vector2(half, half * 0.5), Vector2(half * 2.0, half))
		grid_area.draw_rect(rect, color)
		# Label with value.
		var value_text: String = comp_type.replace("resistor_", "") + "R"
		grid_area.draw_string(ThemeDB.fallback_font, center + Vector2(-half * 0.6, 2.0), value_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 4, Color.WHITE)

	elif comp_type == "led_red":
		var color: Color
		if is_burned:
			color = COLOR_BURNED
		elif is_lit:
			color = COLOR_LED_RED_ON
		else:
			color = COLOR_LED_RED_OFF
		grid_area.draw_circle(center, half * 0.7, color)

	elif comp_type == "led_green":
		var color: Color
		if is_burned:
			color = COLOR_BURNED
		elif is_lit:
			color = COLOR_LED_GREEN_ON
		else:
			color = COLOR_LED_GREEN_OFF
		grid_area.draw_circle(center, half * 0.7, color)

	elif comp_type == "battery_3v":
		# Battery: rectangle with +/- markings.
		var rect: Rect2 = Rect2(center - Vector2(half, half * 0.7), Vector2(half * 2.0, half * 1.4))
		grid_area.draw_rect(rect, COLOR_BATTERY)
		grid_area.draw_string(ThemeDB.fallback_font, center + Vector2(-half * 0.3, -half * 0.1), "+", HORIZONTAL_ALIGNMENT_LEFT, -1, 4, Color.BLACK)
		grid_area.draw_string(ThemeDB.fallback_font, center + Vector2(half * 0.1, half * 0.4), "-", HORIZONTAL_ALIGNMENT_LEFT, -1, 4, Color.BLACK)

	elif comp_type == "wire":
		# Wire segment: small dot.
		grid_area.draw_circle(center, 2.0, COLOR_WIRE)

	else:
		# Unknown component — generic grey rect.
		var rect: Rect2 = Rect2(center - Vector2(half, half), Vector2(half * 2.0, half * 2.0))
		grid_area.draw_rect(rect, Color(0.5, 0.5, 0.5))


## Build a lookup from cell key to component simulation state.
func _build_state_lookup() -> Dictionary:
	var lookup: Dictionary = {}
	var states: Array = _sim_result.get("components_state", [])
	for comp: Dictionary in states:
		var key: String = "%d,%d" % [comp["col"], comp["row"]]
		lookup[key] = comp
	return lookup


# =============================================================================
# Grid input handling
# =============================================================================

## Handle mouse input on the grid area.
func _on_grid_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event as InputEventMouseButton
		var cell: Vector2i = _pos_to_cell(mb.position)

		if mb.pressed:
			if mb.button_index == MOUSE_BUTTON_LEFT:
				if cell.x >= 0:
					_on_grid_left_click(cell.x, cell.y, mb)
			elif mb.button_index == MOUSE_BUTTON_RIGHT:
				if cell.x >= 0:
					_on_grid_right_click(cell.x, cell.y)
		else:
			# Button released — finish wire drag.
			if mb.button_index == MOUSE_BUTTON_LEFT and _is_wire_dragging:
				if cell.x >= 0:
					_finish_wire_drag(cell.x, cell.y)
				else:
					_cancel_wire_drag()

	elif event is InputEventMouseMotion and _is_wire_dragging:
		grid_area.queue_redraw()


## Handle left click on a grid cell.
func _on_grid_left_click(col: int, row: int, event: InputEventMouseButton) -> void:
	var grid: Array = CircuitManager.get_grid(_circuit_id)

	if _selected_component == "wire":
		# Start wire drag.
		_is_wire_dragging = true
		_wire_start_col = col
		_wire_start_row = row
	elif _selected_component != "":
		# Place component.
		if grid[row][col] != "":
			status_label.text = "Cell occupied! Right-click to remove."
			return

		if not CircuitManager.can_afford_component(_selected_component):
			status_label.text = "Not enough materials!"
			return

		if CircuitManager.place_component(_circuit_id, _selected_component, col, row):
			CircuitManager.consume_component_cost(_selected_component)
			status_label.text = "Placed %s at (%d, %d)" % [_selected_component, col, row]
			_sim_result = {}  # Clear old simulation.
			grid_area.queue_redraw()
			_rebuild_palette()  # Update material counts.
		else:
			status_label.text = "Cannot place here."
	else:
		# No component selected — start wire drag from occupied cell.
		if grid[row][col] != "":
			_is_wire_dragging = true
			_wire_start_col = col
			_wire_start_row = row


## Handle right click — remove component.
func _on_grid_right_click(col: int, row: int) -> void:
	var grid: Array = CircuitManager.get_grid(_circuit_id)
	if grid[row][col] != "":
		CircuitManager.remove_component(_circuit_id, col, row)
		_sim_result = {}
		status_label.text = "Removed component at (%d, %d)" % [col, row]
		grid_area.queue_redraw()
	else:
		# Try removing a wire that passes through this cell.
		var wires: Array = CircuitManager.get_wires(_circuit_id)
		for i: int in range(wires.size() - 1, -1, -1):
			var w: Dictionary = wires[i]
			if (w["from_col"] == col and w["from_row"] == row) \
					or (w["to_col"] == col and w["to_row"] == row):
				wires.remove_at(i)
				_sim_result = {}
				status_label.text = "Removed wire at (%d, %d)" % [col, row]
				grid_area.queue_redraw()
				return


## Finish a wire drag — add wire between start and end if adjacent.
func _finish_wire_drag(end_col: int, end_row: int) -> void:
	if _wire_start_col == end_col and _wire_start_row == end_row:
		_cancel_wire_drag()
		return

	if CircuitManager.add_wire(_circuit_id, _wire_start_col, _wire_start_row, end_col, end_row):
		status_label.text = "Wire: (%d,%d) -> (%d,%d)" % [_wire_start_col, _wire_start_row, end_col, end_row]
		_sim_result = {}
	else:
		status_label.text = "Invalid wire — must connect adjacent cells."

	_cancel_wire_drag()
	grid_area.queue_redraw()


## Cancel wire drag.
func _cancel_wire_drag() -> void:
	_is_wire_dragging = false
	_wire_start_col = -1
	_wire_start_row = -1
	grid_area.queue_redraw()


# =============================================================================
# Palette
# =============================================================================

## Rebuild the component palette list.
func _rebuild_palette() -> void:
	for child in palette_list.get_children():
		child.queue_free()

	# Title.
	var title: Label = Label.new()
	title.text = "COMPONENTS"
	title.add_theme_font_size_override("font_size", 6)
	title.add_theme_color_override("font_color", Color(0.4, 0.75, 0.9))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	palette_list.add_child(title)

	# Separator.
	var sep: HSeparator = HSeparator.new()
	palette_list.add_child(sep)

	# Wire (special — always available, drawn as drag).
	_add_palette_entry("wire", "Wire", COLOR_WIRE)

	# Separator before components.
	var sep2: HSeparator = HSeparator.new()
	palette_list.add_child(sep2)

	# Components.
	for comp_type: String in CircuitManager.COMPONENTS:
		if comp_type == "wire":
			continue
		var comp_data: Dictionary = CircuitManager.COMPONENTS[comp_type]
		var display_name: String = _get_component_display_name(comp_type)
		var color: Color = _get_component_color(comp_type)
		_add_palette_entry(comp_type, display_name, color)


## Add a single entry to the palette list.
func _add_palette_entry(comp_type: String, display_name: String, color: Color) -> void:
	var comp_data: Dictionary = CircuitManager.COMPONENTS[comp_type]
	var cost: Dictionary = comp_data.get("cost", {})

	var btn: Button = Button.new()
	btn.custom_minimum_size = Vector2(0, 12)
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.add_theme_font_size_override("font_size", 5)

	# Build label text with cost info.
	var cost_text: String = ""
	var can_afford: bool = CircuitManager.can_afford_component(comp_type)
	for item_id: String in cost:
		var have: int = InventoryManager.get_count(item_id)
		var need: int = cost[item_id]
		var item_name: String = InventoryManager.get_item_name(item_id)
		if cost_text != "":
			cost_text += ", "
		cost_text += "%s %d/%d" % [item_name, have, need]

	btn.text = "%s [%s]" % [display_name, cost_text]

	# Highlight selected.
	if comp_type == _selected_component:
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = Color(0.15, 0.35, 0.2, 0.9)
		style.border_width_left = 2
		style.border_color = COLOR_SELECTED
		style.content_margin_left = 3
		style.content_margin_right = 2
		style.content_margin_top = 1
		style.content_margin_bottom = 1
		btn.add_theme_stylebox_override("normal", style)
		btn.add_theme_color_override("font_color", COLOR_SELECTED)
	else:
		var text_color: Color = Color(0.85, 0.85, 0.8) if can_afford else Color(0.45, 0.45, 0.45)
		btn.add_theme_color_override("font_color", text_color)

	btn.pressed.connect(_on_palette_select.bind(comp_type))
	palette_list.add_child(btn)


## Handle palette component selection.
func _on_palette_select(comp_type: String) -> void:
	if _selected_component == comp_type:
		_selected_component = ""  # Deselect.
	else:
		_selected_component = comp_type

	_rebuild_palette()


## Get a human-readable name for a component type.
func _get_component_display_name(comp_type: String) -> String:
	match comp_type:
		"wire":
			return "Wire"
		"resistor_68":
			return "Resistor 68R"
		"resistor_100":
			return "Resistor 100R"
		"resistor_220":
			return "Resistor 220R"
		"led_red":
			return "LED (Red)"
		"led_green":
			return "LED (Green)"
		"battery_3v":
			return "Battery 3V"
		_:
			return comp_type.capitalize()


## Get a representative color for a component type.
func _get_component_color(comp_type: String) -> Color:
	if comp_type == "wire":
		return COLOR_WIRE
	if comp_type.begins_with("resistor_"):
		return COLOR_RESISTOR
	if comp_type == "led_red":
		return COLOR_LED_RED_OFF
	if comp_type == "led_green":
		return COLOR_LED_GREEN_OFF
	if comp_type == "battery_3v":
		return COLOR_BATTERY
	return Color(0.5, 0.5, 0.5)


# =============================================================================
# Simulation
# =============================================================================

## Run simulation and update display.
func _on_simulate_pressed() -> void:
	_sim_result = CircuitManager.simulate(_circuit_id)

	if _sim_result.get("has_short", false):
		status_label.text = "SHORT CIRCUIT!"
		status_label.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2))
	elif not _sim_result.get("valid", false):
		var errors: Array = _sim_result.get("errors", [])
		if errors.is_empty():
			status_label.text = "No complete circuit found. Wire components together."
		else:
			status_label.text = str(errors[0])
		status_label.add_theme_color_override("font_color", Color(0.95, 0.5, 0.3))
	else:
		var current_ma: float = _sim_result.get("total_current", 0.0) * 1000.0
		status_label.text = "Circuit OK — %.1fmA" % current_ma
		status_label.add_theme_color_override("font_color", Color(0.3, 0.9, 0.4))

	# If puzzle mode, also validate.
	if _puzzle_id != "":
		var puzzle_result: Dictionary = CircuitManager.validate_puzzle(_circuit_id, _puzzle_id)
		if puzzle_result.get("passed", false):
			status_label.text = "PASSED! " + puzzle_result.get("message", "")
			status_label.add_theme_color_override("font_color", Color(0.3, 1.0, 0.5))
		else:
			status_label.text = puzzle_result.get("message", "Not yet correct.")

	grid_area.queue_redraw()


## Clear the circuit.
func _on_clear_pressed() -> void:
	CircuitManager.clear_circuit(_circuit_id)
	_sim_result = {}
	status_label.text = "Circuit cleared."
	status_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	grid_area.queue_redraw()
