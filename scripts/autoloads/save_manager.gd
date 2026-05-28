## SaveManager — Handles saving and loading game state to/from JSON files.
## 5 manual save slots (1-5) + 1 autosave slot (0).
## Autosaves every 2 in-game days and on biome transitions.
extends Node

# --- Signals ---
signal save_completed(slot: int)
signal load_completed(slot: int)
signal save_failed(slot: int, reason: String)
signal load_failed(slot: int, reason: String)

# --- Config ---
const SAVE_DIR: String = "user://saves/"
const SAVE_VERSION: String = "0.1"
const MAX_MANUAL_SLOTS: int = 5
const AUTOSAVE_SLOT: int = 0
const AUTOSAVE_INTERVAL_DAYS: int = 2

# --- Internal ---
## Day number when the last autosave occurred.
var _last_autosave_day: int = 0
## Player node reference (found at runtime).
var _player: Node2D = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Ensure saves directory exists.
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_recursive_absolute(SAVE_DIR)

	# Connect autosave triggers.
	TimeManager.day_changed.connect(_on_day_changed)
	GameManager.biome_changed.connect(_on_biome_changed)


## Save the full game state to a slot (0 = autosave, 1-5 = manual).
## Returns true on success.
func save_game(slot: int) -> bool:
	if slot < 0 or slot > MAX_MANUAL_SLOTS:
		save_failed.emit(slot, "Invalid slot number: %d" % slot)
		return false

	# Build save data.
	var save_data: Dictionary = _build_save_data(slot)

	# Serialize to JSON.
	var json_string: String = JSON.stringify(save_data, "\t")

	# Write file.
	var path: String = _get_save_path(slot)
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		var err_msg: String = "Could not open save file: %s" % path
		push_error("SaveManager: %s" % err_msg)
		save_failed.emit(slot, err_msg)
		return false

	file.store_string(json_string)
	file.close()

	save_completed.emit(slot)
	return true


## Load game state from a slot. Returns true on success.
func load_game(slot: int) -> bool:
	if slot < 0 or slot > MAX_MANUAL_SLOTS:
		load_failed.emit(slot, "Invalid slot number: %d" % slot)
		return false

	var path: String = _get_save_path(slot)
	if not FileAccess.file_exists(path):
		load_failed.emit(slot, "Save file does not exist: %s" % path)
		return false

	# Read file.
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		var err_msg: String = "Could not open save file: %s" % path
		push_error("SaveManager: %s" % err_msg)
		load_failed.emit(slot, err_msg)
		return false

	var json_string: String = file.get_as_text()
	file.close()

	# Parse JSON.
	var json: JSON = JSON.new()
	var parse_result: int = json.parse(json_string)
	if parse_result != OK:
		var err_msg: String = "Invalid JSON in save file: %s" % json.get_error_message()
		push_error("SaveManager: %s" % err_msg)
		load_failed.emit(slot, err_msg)
		return false

	var save_data: Variant = json.data
	if not save_data is Dictionary:
		var err_msg: String = "Save data is not a Dictionary"
		push_error("SaveManager: %s" % err_msg)
		load_failed.emit(slot, err_msg)
		return false

	# Restore state.
	var success: bool = _restore_save_data(save_data as Dictionary)
	if not success:
		load_failed.emit(slot, "Failed to restore save data")
		return false

	load_completed.emit(slot)
	return true


## Save to the autosave slot (slot 0).
func autosave() -> void:
	var success: bool = save_game(AUTOSAVE_SLOT)
	if success:
		_last_autosave_day = TimeManager.current_day


## Get metadata for a save slot (for UI display). Does not load the full file.
func get_save_info(slot: int) -> Dictionary:
	var info: Dictionary = {
		"exists": false,
		"timestamp": "",
		"day_number": 0,
		"slot": slot,
	}

	var path: String = _get_save_path(slot)
	if not FileAccess.file_exists(path):
		return info

	# Read and parse just enough for metadata.
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return info

	var json_string: String = file.get_as_text()
	file.close()

	var json: JSON = JSON.new()
	if json.parse(json_string) != OK:
		return info

	var data: Variant = json.data
	if not data is Dictionary:
		return info

	var dict: Dictionary = data as Dictionary
	info["exists"] = true
	info["timestamp"] = dict.get("timestamp", "unknown")
	if dict.has("time") and dict["time"] is Dictionary:
		info["day_number"] = int(dict["time"].get("current_day", 0))
	else:
		info["day_number"] = 0

	return info


## Delete a save file. Returns true on success.
func delete_save(slot: int) -> bool:
	var path: String = _get_save_path(slot)
	if not FileAccess.file_exists(path):
		return false

	var err: Error = DirAccess.remove_absolute(path)
	return err == OK


## Check if a save file exists for the given slot.
func has_save(slot: int) -> bool:
	return FileAccess.file_exists(_get_save_path(slot))


# --- Internal helpers ---

## Build the full save data dictionary from all managers.
func _build_save_data(slot: int) -> Dictionary:
	_find_player()

	var player_pos: Dictionary = {"x": 0.0, "y": 0.0}
	if _player and is_instance_valid(_player):
		player_pos = {"x": _player.global_position.x, "y": _player.global_position.y}

	var save_data: Dictionary = {
		"version": SAVE_VERSION,
		"timestamp": Time.get_datetime_string_from_system(true),
		"slot": slot,

		"player": {
			"position": player_pos,
			"stats": GameManager.serialize(),
		},

		"time": TimeManager.serialize(),

		"inventory": InventoryManager.serialize(),

		"crafting": CraftingManager.serialize(),

		"robots": RobotManager.serialize(),

		"quests": {
			"active": [],
			"completed": [],
		},

		"world": {
			"current_biome": GameManager.current_biome,
		},
	}

	return save_data


## Restore all manager state from a save data dictionary.
func _restore_save_data(data: Dictionary) -> bool:
	# Version check.
	var version: String = str(data.get("version", ""))
	if version == "":
		push_warning("SaveManager: Save file has no version info")

	_find_player()

	# Restore player position.
	if data.has("player") and data["player"] is Dictionary:
		var player_data: Dictionary = data["player"] as Dictionary
		if _player and is_instance_valid(_player):
			if player_data.has("position") and player_data["position"] is Dictionary:
				var pos: Dictionary = player_data["position"] as Dictionary
				_player.global_position = Vector2(
					float(pos.get("x", 0.0)),
					float(pos.get("y", 0.0))
				)
		# Restore player stats.
		if player_data.has("stats") and player_data["stats"] is Dictionary:
			GameManager.deserialize(player_data["stats"] as Dictionary)

	# Restore time.
	if data.has("time") and data["time"] is Dictionary:
		TimeManager.deserialize(data["time"] as Dictionary)

	# Restore inventory.
	if data.has("inventory") and data["inventory"] is Dictionary:
		InventoryManager.deserialize(data["inventory"] as Dictionary)

	# Restore crafting.
	if data.has("crafting") and data["crafting"] is Dictionary:
		CraftingManager.deserialize(data["crafting"] as Dictionary)

	# Restore robots.
	if data.has("robots") and data["robots"] is Array:
		RobotManager.deserialize(data["robots"] as Array)

	# Restore world state.
	if data.has("world") and data["world"] is Dictionary:
		var world_data: Dictionary = data["world"] as Dictionary
		GameManager.current_biome = str(world_data.get("current_biome", "alkaline_flats"))

	return true


## Get the file path for a save slot.
func _get_save_path(slot: int) -> String:
	if slot == AUTOSAVE_SLOT:
		return SAVE_DIR + "autosave.json"
	return SAVE_DIR + "save_%d.json" % slot


## Find the player node in the scene tree.
func _find_player() -> void:
	_player = get_tree().get_first_node_in_group("player")
	if _player == null:
		# Fallback: look for a Player node in the current scene.
		var scene: Node = get_tree().current_scene
		if scene and scene.has_node("Player"):
			_player = scene.get_node("Player") as Node2D


## Autosave trigger: every AUTOSAVE_INTERVAL_DAYS in-game days.
func _on_day_changed(day: int) -> void:
	if day - _last_autosave_day >= AUTOSAVE_INTERVAL_DAYS:
		autosave()


## Autosave trigger: biome transition.
func _on_biome_changed(_new_biome: String) -> void:
	autosave()
