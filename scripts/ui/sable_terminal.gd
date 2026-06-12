## SableTerminal — CRT-style terminal for SABLE messages, hints, and alerts.
## Opens with backtick key (open_terminal). Typewriter text, scrollable log.
extends CanvasLayer

# --- Node references ---
@onready var panel: PanelContainer = $Panel
@onready var scroll_container: ScrollContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer
@onready var log_container: VBoxContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/LogContainer
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var close_hint: Label = $Panel/MarginContainer/VBoxContainer/CloseHint

# --- State ---
var is_open: bool = false

## Message log: Array of {text: String, type: String, timestamp: String}
var _message_log: Array[Dictionary] = []

const MAX_MESSAGES: int = 20

# --- Typewriter for latest message ---
var _typewriter_text: String = ""
var _typewriter_visible: int = 0
var _typewriter_timer: float = 0.0
var _typewriter_done: bool = true
var _typewriter_label: Label = null

const TYPEWRITER_SPEED: float = 40.0  # Characters per second.

# --- Message type colors ---
const TYPE_COLORS: Dictionary = {
	"sable": Color(0.2, 0.85, 0.4),     # SABLE green
	"hint": Color(0.4, 0.8, 0.6),       # Softer green
	"alert": Color(0.95, 0.4, 0.3),     # Red alert
	"system": Color(0.7, 0.7, 0.7),     # Grey
}


func _ready() -> void:
	# Start closed.
	panel.visible = false
	is_open = false


func _process(delta: float) -> void:
	if not _typewriter_done and _typewriter_label and is_open:
		_typewriter_timer += delta
		var chars_to_show: int = int(_typewriter_timer * TYPEWRITER_SPEED)
		if chars_to_show > _typewriter_visible:
			_typewriter_visible = chars_to_show
			_typewriter_label.visible_characters = mini(_typewriter_visible, _typewriter_text.length())
			if _typewriter_visible >= _typewriter_text.length():
				_typewriter_done = true
				# Auto-scroll to bottom.
				_scroll_to_bottom()


func _unhandled_input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("pause"):
		toggle()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("open_terminal"):
		toggle()
		get_viewport().set_input_as_handled()


## Toggle the terminal open/closed.
func toggle() -> void:
	is_open = !is_open
	panel.visible = is_open
	if is_open:
		_rebuild_log_display()
		_scroll_to_bottom()


## Add a message to the log.
func add_message(text: String, type: String = "system") -> void:
	var timestamp: String = TimeManager.get_time_string()
	var entry: Dictionary = {
		"text": text,
		"type": type,
		"timestamp": timestamp,
	}
	_message_log.append(entry)

	# Trim to max messages.
	while _message_log.size() > MAX_MESSAGES:
		_message_log.pop_front()

	# If the terminal is open, add the label live with typewriter.
	if is_open:
		_add_message_label(entry, true)
	# If closed, just store it — will display when opened.


## SABLE's contextual hint shortcut.
func show_hint(text: String) -> void:
	add_message(text, "hint")


## Rebuild all log labels from stored messages.
func _rebuild_log_display() -> void:
	# Clear existing labels.
	for child: Node in log_container.get_children():
		child.queue_free()

	# Add all stored messages (no typewriter on rebuild).
	for entry: Dictionary in _message_log:
		_add_message_label(entry, false)


## Add a single message label to the log container.
func _add_message_label(entry: Dictionary, use_typewriter: bool) -> void:
	var label: Label = Label.new()
	var prefix: String = "[%s] " % entry["type"].to_upper()
	var full_text: String = prefix + entry["text"]
	label.text = full_text
	label.add_theme_font_size_override("font_size", 6)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# Apply type color.
	var type_key: String = entry["type"]
	if type_key in TYPE_COLORS:
		label.add_theme_color_override("font_color", TYPE_COLORS[type_key])
	else:
		label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))

	log_container.add_child(label)

	if use_typewriter:
		_typewriter_text = full_text
		_typewriter_visible = 0
		_typewriter_timer = 0.0
		_typewriter_done = false
		_typewriter_label = label
		label.visible_characters = 0
	else:
		label.visible_characters = -1  # Show all.

	_scroll_to_bottom()


## Scroll the log to the bottom.
func _scroll_to_bottom() -> void:
	# Defer to next frame so layout is updated.
	await get_tree().process_frame
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
