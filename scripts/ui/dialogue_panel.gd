## DialoguePanel — Bottom-of-screen dialogue UI with typewriter effect.
## Shows speaker name, text, portrait placeholder, and choice buttons.
extends CanvasLayer

# --- Node references ---
@onready var panel: PanelContainer = $Panel
@onready var portrait_rect: ColorRect = $Panel/HBoxContainer/PortraitRect
@onready var speaker_label: Label = $Panel/HBoxContainer/VBoxContainer/SpeakerLabel
@onready var text_label: Label = $Panel/HBoxContainer/VBoxContainer/TextLabel
@onready var choices_container: VBoxContainer = $Panel/HBoxContainer/VBoxContainer/ChoicesContainer
@onready var advance_hint: Label = $Panel/HBoxContainer/VBoxContainer/AdvanceHint

# --- Typewriter ---
const TYPEWRITER_SPEED: float = 30.0  # Characters per second.
var _full_text: String = ""
var _visible_chars: int = 0
var _typewriter_timer: float = 0.0
var _typewriter_done: bool = true

# --- Dialogue state ---
var _has_choices: bool = false
var _choices: Array = []

# --- NPC color map (placeholder portraits) ---
const NPC_COLORS: Dictionary = {
	"sable": Color(0.2, 0.8, 0.4),    # Green (system/AI)
	"wren": Color(0.85, 0.55, 0.3),    # Warm orange-brown
	"rootknot": Color(0.5, 0.35, 0.25), # Earth brown
	"cass": Color(0.3, 0.6, 0.9),      # Blue (AI drone)
	"mira": Color(0.7, 0.4, 0.85),     # Purple (hologram)
}

const NARRATION_COLOR: Color = Color(0.6, 0.6, 0.6)
const DEFAULT_COLOR: Color = Color(0.5, 0.5, 0.5)


func _ready() -> void:
	# Connect to DialogueManager signals.
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_line.connect(_on_dialogue_line)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

	# Start hidden.
	panel.visible = false


func _process(delta: float) -> void:
	if not _typewriter_done:
		_typewriter_timer += delta
		var chars_to_show: int = int(_typewriter_timer * TYPEWRITER_SPEED)
		if chars_to_show > _visible_chars:
			_visible_chars = chars_to_show
			text_label.visible_characters = mini(_visible_chars, _full_text.length())
			if _visible_chars >= _full_text.length():
				_typewriter_done = true
				_show_advance_ui()


func _unhandled_input(event: InputEvent) -> void:
	if not panel.visible:
		return

	# Advance with E key.
	if event.is_action_pressed("interact"):
		_handle_advance()
		get_viewport().set_input_as_handled()
		return

	# Also advance on mouse click.
	if event is InputEventMouseButton and event.pressed:
		_handle_advance()
		get_viewport().set_input_as_handled()
		return


## Handle advancing dialogue or completing typewriter.
func _handle_advance() -> void:
	if not _typewriter_done:
		# Skip typewriter — show full text immediately.
		_visible_chars = _full_text.length()
		text_label.visible_characters = _full_text.length()
		_typewriter_done = true
		_show_advance_ui()
		return

	if _has_choices:
		# Player must pick a choice — don't auto-advance.
		return

	# Advance to next line.
	DialogueManager.advance_dialogue()


## Show the advance hint or choice buttons after typewriter finishes.
func _show_advance_ui() -> void:
	if _has_choices:
		choices_container.visible = true
		advance_hint.visible = false
	else:
		choices_container.visible = false
		advance_hint.visible = true


# --- Signal callbacks ---

func _on_dialogue_started(_npc_id: String) -> void:
	panel.visible = true


func _on_dialogue_line(speaker: String, text: String, choices: Array) -> void:
	# Set speaker name.
	if speaker == "":
		speaker_label.text = ""
	else:
		speaker_label.text = speaker

	# Set portrait color.
	var npc_key: String = speaker.to_lower()
	if npc_key in NPC_COLORS:
		portrait_rect.color = NPC_COLORS[npc_key]
	elif speaker == "":
		portrait_rect.color = NARRATION_COLOR
	else:
		portrait_rect.color = DEFAULT_COLOR

	# Start typewriter effect.
	_full_text = text
	_visible_chars = 0
	_typewriter_timer = 0.0
	_typewriter_done = false
	text_label.text = text
	text_label.visible_characters = 0

	# Handle choices.
	_choices = choices
	_has_choices = choices.size() > 0

	# Clear old choice buttons.
	for child: Node in choices_container.get_children():
		child.queue_free()

	# Hide choices and advance hint until typewriter completes.
	choices_container.visible = false
	advance_hint.visible = false

	# Create choice buttons (hidden until typewriter finishes).
	if _has_choices:
		for i: int in range(choices.size()):
			var choice: Dictionary = choices[i]
			var btn: Button = Button.new()
			btn.text = choice.get("text", "...")
			btn.add_theme_font_size_override("font_size", 6)
			btn.pressed.connect(_on_choice_pressed.bind(i))
			choices_container.add_child(btn)


func _on_dialogue_ended() -> void:
	panel.visible = false
	_full_text = ""
	_has_choices = false
	_choices = []

	# Clear choice buttons.
	for child: Node in choices_container.get_children():
		child.queue_free()


func _on_choice_pressed(index: int) -> void:
	DialogueManager.select_choice(index)
