## SaveLoadPanel — Save/Load slot selection UI.
## Shows 5 manual slots + 1 autosave slot (load-only).
## Can operate in "save" or "load" mode.
extends CanvasLayer

# --- Signals ---
signal closed()

# --- Node references ---
@onready var panel: PanelContainer = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBox/TitleLabel
@onready var slot_container: VBoxContainer = $Panel/MarginContainer/VBox/ScrollContainer/SlotContainer
@onready var btn_back: Button = $Panel/MarginContainer/VBox/BtnBack

# --- State ---
var is_open: bool = false
## "save" or "load"
var mode: String = "save"

# Slot button references (built at runtime).
var _slot_buttons: Array[Button] = []
# Confirmation dialog reference.
var _confirm_dialog: PanelContainer = null
var _confirm_label: Label = null
var _confirm_yes: Button = null
var _confirm_no: Button = null
var _pending_slot: int = -1


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.visible = false
	is_open = false

	btn_back.pressed.connect(_on_back_pressed)

	# Build slot buttons.
	_build_slots()

	# Build confirmation dialog (hidden by default).
	_build_confirm_dialog()


## Open the panel in the given mode ("save" or "load").
func open(open_mode: String) -> void:
	mode = open_mode
	is_open = true
	panel.visible = true

	if mode == "save":
		title_label.text = "SAVE GAME"
	else:
		title_label.text = "LOAD GAME"

	_refresh_slots()
	_hide_confirm()


## Close the panel.
func close() -> void:
	is_open = false
	panel.visible = false
	_hide_confirm()
	closed.emit()


## Build the 6 slot buttons (0 = autosave, 1-5 = manual).
func _build_slots() -> void:
	_slot_buttons.clear()

	for i in range(6):
		var btn: Button = Button.new()
		btn.custom_minimum_size = Vector2(0, 14)
		btn.add_theme_font_size_override("font_size", 5)
		btn.pressed.connect(_on_slot_pressed.bind(i))
		slot_container.add_child(btn)
		_slot_buttons.append(btn)


## Refresh slot button labels with current save info.
func _refresh_slots() -> void:
	for i in range(6):
		var info: Dictionary = SaveManager.get_save_info(i)
		var btn: Button = _slot_buttons[i]

		if i == 0:
			# Autosave slot.
			if info["exists"]:
				btn.text = "[Auto] Day %d - %s" % [info["day_number"], _format_timestamp(info["timestamp"])]
			else:
				btn.text = "[Auto] Empty"
			# Autosave slot is load-only.
			btn.disabled = (mode == "save")
		else:
			# Manual slots.
			if info["exists"]:
				btn.text = "Slot %d: Day %d - %s" % [i, info["day_number"], _format_timestamp(info["timestamp"])]
			else:
				btn.text = "Slot %d: Empty" % i
			# In load mode, disable empty slots.
			btn.disabled = (mode == "load" and not info["exists"])


## Format a timestamp string for display (show date + time, trim seconds).
func _format_timestamp(ts: String) -> String:
	# Timestamps come as "2026-05-25T12:00:00" — show just the date and HH:MM.
	if ts.length() >= 16:
		return ts.substr(0, 16).replace("T", " ")
	return ts


## Handle a slot button press.
func _on_slot_pressed(slot: int) -> void:
	if mode == "save":
		# Check if slot has existing data — if so, confirm overwrite.
		if SaveManager.has_save(slot):
			_pending_slot = slot
			_show_confirm("Overwrite Slot %d?" % slot)
		else:
			_do_save(slot)
	else:
		_do_load(slot)


## Perform the save operation.
func _do_save(slot: int) -> void:
	var success: bool = SaveManager.save_game(slot)
	if success:
		_refresh_slots()
	else:
		push_warning("SaveLoadPanel: Save failed for slot %d" % slot)


## Perform the load operation.
func _do_load(slot: int) -> void:
	close()
	# Unpause before loading so the game can resume.
	get_tree().paused = false
	var success: bool = SaveManager.load_game(slot)
	if not success:
		push_warning("SaveLoadPanel: Load failed for slot %d" % slot)


## Build the overwrite confirmation dialog (child of panel).
func _build_confirm_dialog() -> void:
	_confirm_dialog = PanelContainer.new()
	_confirm_dialog.name = "ConfirmDialog"

	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.1, 0.18, 0.95)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.6, 0.3, 0.3)
	style.corner_radius_top_left = 2
	style.corner_radius_top_right = 2
	style.corner_radius_bottom_left = 2
	style.corner_radius_bottom_right = 2
	_confirm_dialog.add_theme_stylebox_override("panel", style)

	_confirm_dialog.anchors_preset = Control.PRESET_CENTER
	_confirm_dialog.custom_minimum_size = Vector2(90, 40)

	var margin: MarginContainer = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 4)
	margin.add_theme_constant_override("margin_top", 3)
	margin.add_theme_constant_override("margin_right", 4)
	margin.add_theme_constant_override("margin_bottom", 3)
	_confirm_dialog.add_child(margin)

	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 3)
	margin.add_child(vbox)

	_confirm_label = Label.new()
	_confirm_label.text = "Overwrite?"
	_confirm_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_confirm_label.add_theme_font_size_override("font_size", 6)
	vbox.add_child(_confirm_label)

	var hbox: HBoxContainer = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 4)
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(hbox)

	_confirm_yes = Button.new()
	_confirm_yes.text = "Yes"
	_confirm_yes.add_theme_font_size_override("font_size", 5)
	_confirm_yes.custom_minimum_size = Vector2(30, 0)
	_confirm_yes.pressed.connect(_on_confirm_yes)
	hbox.add_child(_confirm_yes)

	_confirm_no = Button.new()
	_confirm_no.text = "No"
	_confirm_no.add_theme_font_size_override("font_size", 5)
	_confirm_no.custom_minimum_size = Vector2(30, 0)
	_confirm_no.pressed.connect(_on_confirm_no)
	hbox.add_child(_confirm_no)

	panel.add_child(_confirm_dialog)
	_confirm_dialog.visible = false


## Show the confirmation dialog.
func _show_confirm(msg: String) -> void:
	_confirm_label.text = msg
	_confirm_dialog.visible = true


## Hide the confirmation dialog.
func _hide_confirm() -> void:
	if _confirm_dialog:
		_confirm_dialog.visible = false
	_pending_slot = -1


func _on_confirm_yes() -> void:
	if _pending_slot >= 0:
		_do_save(_pending_slot)
	_hide_confirm()


func _on_confirm_no() -> void:
	_hide_confirm()


func _on_back_pressed() -> void:
	close()
