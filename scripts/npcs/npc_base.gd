## NPCBase — Base class for all AstroCode NPCs.
## Handles player proximity detection, speech bubble, and dialogue triggering.
class_name NPCBase
extends StaticBody2D

# --- Exports ---
@export var npc_id: String = ""
@export var npc_name: String = ""
@export var npc_color: Color = Color(0.7, 0.7, 0.7, 1.0)

# --- Detection ranges (in pixels; 1 tile = 16px) ---
const SPEECH_BUBBLE_RANGE: float = 64.0  # 4 tiles
const INTERACT_RANGE: float = 32.0       # 2 tiles

# --- Node references ---
var _sprite: ColorRect = null
var _speech_bubble: ColorRect = null
var _detection_area: Area2D = null

# --- Internal ---
var _player_nearby: bool = false
var _player_ref: Node2D = null


func _ready() -> void:
	# Cache node references.
	_sprite = $Sprite as ColorRect
	_speech_bubble = $SpeechBubble as ColorRect
	_detection_area = $DetectionArea as Area2D

	# Apply the placeholder color.
	if _sprite:
		_sprite.color = npc_color

	# Show the NPC's name above their head (hidden for unnamed base NPCs).
	var name_label: Label = $NameLabel as Label
	if name_label:
		name_label.text = npc_name
		name_label.visible = npc_name != ""

	# Hide speech bubble initially.
	if _speech_bubble:
		_speech_bubble.visible = false

	# Connect detection area signals.
	_detection_area.body_entered.connect(_on_detection_body_entered)
	_detection_area.body_exited.connect(_on_detection_body_exited)

	# Add to NPC group for easy lookup.
	add_to_group("npcs")

	# Connect to dialogue manager for state tracking.
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func _physics_process(_delta: float) -> void:
	if not _player_nearby or _player_ref == null:
		return

	# Update speech bubble visibility based on distance.
	var dist: float = global_position.distance_to(_player_ref.global_position)

	if _speech_bubble:
		_speech_bubble.visible = dist <= SPEECH_BUBBLE_RANGE and not DialogueManager.is_dialogue_active()


## Determine the dialogue context based on quest state.
func get_dialogue_context() -> String:
	# Check for quest-specific contexts. NPCs can override this.
	# Default progression: first_meeting -> quest_active -> quest_complete -> idle.
	var npc_quests: Array[String] = _get_npc_quests()

	for quest_id: String in npc_quests:
		if DialogueManager.is_quest_complete(quest_id):
			return "quest_complete"
		if DialogueManager.is_quest_active(quest_id):
			return "quest_active"

	# First meeting if no quests have been started.
	if _has_context("first_meeting"):
		var any_quest_started: bool = false
		for quest_id: String in npc_quests:
			if DialogueManager.is_quest_active(quest_id) or DialogueManager.is_quest_complete(quest_id):
				any_quest_started = true
				break
		if not any_quest_started:
			return "first_meeting"

	# First boot for SABLE.
	if _has_context("first_boot"):
		return "first_boot"

	return "idle"


## Called when the player interacts with this NPC.
func interact() -> void:
	if DialogueManager.is_dialogue_active():
		return

	var context: String = get_dialogue_context()
	DialogueManager.start_dialogue(npc_id, context)


## Get the interaction prompt text for the HUD.
func get_interact_prompt() -> String:
	if DialogueManager.is_dialogue_active():
		return ""
	return "Press E to talk to %s" % npc_name


## Return quest IDs associated with this NPC. Override in subclasses.
func _get_npc_quests() -> Array[String]:
	# Default: derive from quest_data in DialogueManager.
	var quests: Array[String] = []
	for quest_id: String in DialogueManager.quest_data.keys():
		var info: Dictionary = DialogueManager.quest_data[quest_id]
		if info.get("npc_id", "") == npc_id:
			quests.append(quest_id)
	return quests


## Check if this NPC has dialogue data for a given context.
func _has_context(context: String) -> bool:
	if DialogueManager._dialogue_cache.has(npc_id):
		return DialogueManager._dialogue_cache[npc_id].has(context)
	return false


func _on_detection_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_nearby = true
		_player_ref = body


func _on_detection_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_nearby = false
		_player_ref = null
		if _speech_bubble:
			_speech_bubble.visible = false


func _on_dialogue_ended() -> void:
	# Re-check speech bubble state after dialogue closes.
	if _player_nearby and _player_ref and _speech_bubble:
		var dist: float = global_position.distance_to(_player_ref.global_position)
		_speech_bubble.visible = dist <= SPEECH_BUBBLE_RANGE
