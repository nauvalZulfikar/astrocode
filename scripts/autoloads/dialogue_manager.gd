## DialogueManager — Global dialogue and quest state singleton.
## Loads dialogue from JSON, drives dialogue sequences, and tracks quest progress.
extends Node

# --- Signals ---
signal dialogue_started(npc_id: String)
signal dialogue_line(speaker: String, text: String, choices: Array)
signal dialogue_ended()
signal quest_accepted(quest_id: String)
signal quest_completed(quest_id: String)

# --- Quest state ---
var active_quests: Array[String] = []
var completed_quests: Array[String] = []

## Quest metadata: {quest_id: {name, description, objectives, npc_id, reward}}
var quest_data: Dictionary = {}

const MAX_ACTIVE_QUESTS: int = 5

# --- Dialogue state ---
## Loaded dialogue trees per NPC: {npc_id: Dictionary}
var _dialogue_cache: Dictionary = {}

## Currently active dialogue sequence.
var _current_npc_id: String = ""
var _current_lines: Array = []
var _current_line_index: int = -1
var _is_active: bool = false

## Pending choices after lines finish (old format: player_responses at context level).
var _pending_responses: Array = []
var _responses_shown: bool = false

## The current context dictionary (for resolving branch keys in old format).
var _current_context_data: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_preload_all_dialogue()


## Preload all dialogue JSON files from the resources/dialogue/ directory.
func _preload_all_dialogue() -> void:
	var dir: DirAccess = DirAccess.open("res://resources/dialogue/")
	if dir == null:
		push_warning("DialogueManager: Could not open res://resources/dialogue/")
		return

	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var npc_id: String = file_name.get_basename()
			_load_dialogue_file(npc_id, "res://resources/dialogue/" + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()


## Load a single dialogue JSON file and cache it.
func _load_dialogue_file(npc_id: String, path: String) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("DialogueManager: Could not open '%s'" % path)
		return

	var json_text: String = file.get_as_text()
	file.close()

	var json: JSON = JSON.new()
	var error: Error = json.parse(json_text)
	if error != OK:
		push_warning("DialogueManager: JSON parse error in '%s': %s" % [path, json.get_error_message()])
		return

	_dialogue_cache[npc_id] = json.data


## Start a dialogue sequence for the given NPC and context.
## Supports two JSON formats:
## - New format: choices inline in line dicts as "choices" array.
## - Old format: "player_responses" at context level, branches as sibling keys.
func start_dialogue(npc_id: String, context: String) -> void:
	if _is_active:
		return

	if not _dialogue_cache.has(npc_id):
		push_warning("DialogueManager: No dialogue data for NPC '%s'" % npc_id)
		return

	var npc_data: Dictionary = _dialogue_cache[npc_id]
	if not npc_data.has(context):
		push_warning("DialogueManager: No context '%s' for NPC '%s'" % [context, npc_id])
		return

	var context_data: Variant = npc_data[context]

	# Old format stores context data as a Dictionary with "lines" key.
	# But branch targets (e.g. "first_meeting_friendly") are plain Arrays.
	if context_data is Array:
		# This is a branch target — an array of line dicts.
		_current_npc_id = npc_id
		_current_lines = context_data as Array
		_current_line_index = -1
		_pending_responses = []
		_responses_shown = false
		_current_context_data = {}
		_is_active = true
		dialogue_started.emit(npc_id)
		advance_dialogue()
		return

	# Dictionary-based context.
	var ctx: Dictionary = context_data as Dictionary
	_current_npc_id = npc_id
	_current_lines = ctx.get("lines", [])
	_current_line_index = -1
	_current_context_data = ctx
	_is_active = true

	# Check for old-format player_responses (choices at context level).
	_pending_responses = ctx.get("player_responses", [])
	_responses_shown = false

	# Check for quest data — new format: "quest" dict, old format: "quest_name" + "objectives".
	if ctx.has("quest"):
		var quest: Dictionary = ctx["quest"]
		var quest_id: String = quest.get("id", "")
		if quest_id != "" and not quest_data.has(quest_id):
			quest_data[quest_id] = {
				"name": quest.get("name", quest_id),
				"description": quest.get("description", ""),
				"objectives": quest.get("objectives", []),
				"npc_id": npc_id,
				"reward": quest.get("reward", ""),
			}
			accept_quest(quest_id)
	elif ctx.has("quest_name"):
		# Old format: quest_name and objectives at context level.
		var quest_id: String = context  # Use context key as quest ID.
		if not quest_data.has(quest_id):
			quest_data[quest_id] = {
				"name": ctx.get("quest_name", quest_id),
				"description": ctx.get("context", ""),
				"objectives": ctx.get("objectives", []),
				"npc_id": npc_id,
				"reward": ctx.get("reward", ""),
			}
			accept_quest(quest_id)

	dialogue_started.emit(npc_id)
	advance_dialogue()


## Advance to the next dialogue line. Emits dialogue_line or dialogue_ended.
func advance_dialogue() -> void:
	if not _is_active:
		return

	_current_line_index += 1

	if _current_line_index >= _current_lines.size():
		# Check for old-format player_responses pending after all lines.
		if not _pending_responses.is_empty() and not _responses_shown:
			_responses_shown = true
			var choices: Array = []
			for resp: Variant in _pending_responses:
				var r: Dictionary = resp as Dictionary
				choices.append({"text": r.get("text", "..."), "next": r.get("next", "")})
			# Show a prompt line with the choices.
			dialogue_line.emit("", "", choices)
			return

		# End of dialogue.
		_end_dialogue()
		return

	var line: Dictionary = _current_lines[_current_line_index]
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var choices: Array = line.get("choices", [])

	dialogue_line.emit(speaker, text, choices)


## Player selects a choice by index. Branches to the next context.
func select_choice(index: int) -> void:
	if not _is_active:
		return

	# Determine which choices array to use.
	var choices: Array = []

	if _current_line_index >= 0 and _current_line_index < _current_lines.size():
		# New format: choices inline in the current line.
		var line: Dictionary = _current_lines[_current_line_index]
		choices = line.get("choices", [])

	if choices.is_empty() and not _pending_responses.is_empty():
		# Old format: player_responses shown after all lines.
		for resp: Variant in _pending_responses:
			var r: Dictionary = resp as Dictionary
			choices.append({"text": r.get("text", "..."), "next": r.get("next", "")})

	if index < 0 or index >= choices.size():
		return

	var choice: Dictionary = choices[index]
	var next_context: String = choice.get("next", "")
	var saved_npc_id: String = _current_npc_id
	var saved_context_data: Dictionary = _current_context_data

	# End current dialogue state.
	_is_active = false
	_current_lines = []
	_current_line_index = -1
	_pending_responses = []

	if next_context == "":
		_current_npc_id = ""
		_current_context_data = {}
		dialogue_ended.emit()
		return

	# Old format: branch target may be a sibling key inside the same context dict.
	if saved_context_data.has(next_context):
		var branch_data: Variant = saved_context_data[next_context]
		if branch_data is Array:
			_current_npc_id = saved_npc_id
			_current_lines = branch_data as Array
			_current_line_index = -1
			_current_context_data = {}
			_is_active = true
			dialogue_started.emit(saved_npc_id)
			advance_dialogue()
			return

	# Otherwise, look for the branch as a top-level context key in the NPC data.
	_current_npc_id = saved_npc_id
	start_dialogue(saved_npc_id, next_context)


## Accept a quest if under the active limit.
func accept_quest(quest_id: String) -> bool:
	if is_quest_active(quest_id) or is_quest_complete(quest_id):
		return false
	if active_quests.size() >= MAX_ACTIVE_QUESTS:
		push_warning("DialogueManager: Max active quests (%d) reached." % MAX_ACTIVE_QUESTS)
		return false

	active_quests.append(quest_id)
	quest_accepted.emit(quest_id)
	return true


## Complete a quest — move from active to completed.
func complete_quest(quest_id: String) -> void:
	if not is_quest_active(quest_id):
		push_warning("DialogueManager: Quest '%s' is not active." % quest_id)
		return

	active_quests.erase(quest_id)
	completed_quests.append(quest_id)
	quest_completed.emit(quest_id)


## Check if a quest is currently active.
func is_quest_active(quest_id: String) -> bool:
	return quest_id in active_quests


## Check if a quest has been completed.
func is_quest_complete(quest_id: String) -> bool:
	return quest_id in completed_quests


## Returns true if a dialogue sequence is currently playing.
func is_dialogue_active() -> bool:
	return _is_active


## Get quest info dictionary for journal display.
func get_quest_info(quest_id: String) -> Dictionary:
	if quest_data.has(quest_id):
		return quest_data[quest_id]
	return {}


## Get all active quest entries for journal display.
func get_active_quest_entries() -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	for quest_id: String in active_quests:
		var info: Dictionary = get_quest_info(quest_id)
		info["id"] = quest_id
		info["status"] = "active"
		entries.append(info)
	return entries


## Get all completed quest entries for journal display.
func get_completed_quest_entries() -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	for quest_id: String in completed_quests:
		var info: Dictionary = get_quest_info(quest_id)
		info["id"] = quest_id
		info["status"] = "completed"
		entries.append(info)
	return entries


## End the current dialogue sequence.
func _end_dialogue() -> void:
	_is_active = false
	_current_lines = []
	_current_line_index = -1
	_current_npc_id = ""
	_pending_responses = []
	_responses_shown = false
	_current_context_data = {}
	dialogue_ended.emit()
