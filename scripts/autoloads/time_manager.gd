## TimeManager — Day/night cycle and in-game clock.
## 1 real minute = 1 in-game hour. 14 real minutes = 1 in-game day (14 hours).
## Day phase: hours 0-8 (9 real minutes). Night phase: hours 9-13 (5 real minutes).
extends Node

# --- Signals ---
signal hour_changed(hour: int)
signal day_changed(day: int)
signal night_started()
signal day_started()

# --- Constants ---
## Real seconds per in-game hour.
const SECONDS_PER_HOUR: float = 60.0
## Total in-game hours per day.
const HOURS_PER_DAY: int = 14
## Hour at which night begins (0-indexed).
const NIGHT_START_HOUR: int = 9

# --- State ---
## Current fractional hour (0.0 to 13.999...).
var current_hour: float = 6.0
## Current day number (starts at 1).
var current_day: int = 1
## Whether it is currently night.
var is_night: bool = false
## Time scale multiplier (1.0 = normal, 1.5 = relaxed mode would use ~0.67).
var time_scale: float = 1.0
## Pause the clock (e.g., during menus).
var paused: bool = false

# --- Internal ---
var _last_whole_hour: int = 6


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_last_whole_hour = int(current_hour)
	_update_night_flag()


func _process(delta: float) -> void:
	if paused:
		return

	# Advance time: delta (real seconds) / 60 = in-game hours elapsed.
	var hours_elapsed: float = (delta * time_scale) / SECONDS_PER_HOUR
	current_hour += hours_elapsed

	# --- Day rollover ---
	while current_hour >= float(HOURS_PER_DAY):
		current_hour -= float(HOURS_PER_DAY)
		current_day += 1
		GameManager.day_number = current_day
		day_changed.emit(current_day)

	# --- Hour tick ---
	var whole_hour: int = int(current_hour)
	if whole_hour != _last_whole_hour:
		_last_whole_hour = whole_hour
		hour_changed.emit(whole_hour)

		# Day/night transitions.
		if whole_hour == NIGHT_START_HOUR and not is_night:
			is_night = true
			night_started.emit()
		elif whole_hour == 0 and is_night:
			is_night = false
			day_started.emit()

	_update_night_flag()

	# --- Tick player stats ---
	GameManager.tick_stats(delta * time_scale)


## Update the is_night flag without emitting signals (used on init).
func _update_night_flag() -> void:
	is_night = int(current_hour) >= NIGHT_START_HOUR


## Human-readable time string: "Day 3 - 09:30"
func get_time_string() -> String:
	var h: int = int(current_hour)
	var m: int = int((current_hour - float(h)) * 60.0)
	return "Day %d - %02d:%02d" % [current_day, h, m]


## Progress through the full day as 0.0 to 1.0 (for lighting lerp).
func get_day_progress() -> float:
	return current_hour / float(HOURS_PER_DAY)


## Skip to next dawn (sleep mechanic). Energy restored to 80, hunger ticks.
func skip_to_dawn() -> void:
	if not is_night:
		return  # Already daytime; nothing to skip.

	# Calculate remaining night hours for hunger tick.
	var remaining_hours: float = float(HOURS_PER_DAY) - current_hour
	# Hunger cost: ~1 per 7 in-game hours → remaining_hours / 7.
	var hunger_cost: float = remaining_hours / 7.0
	GameManager.modify_stat("hunger", -hunger_cost)
	GameManager.modify_stat("energy", 80.0 - GameManager.get_stat("energy"))

	# Jump to dawn.
	current_hour = 0.0
	current_day += 1
	GameManager.day_number = current_day
	_last_whole_hour = 0
	is_night = false

	day_changed.emit(current_day)
	day_started.emit()
	hour_changed.emit(0)


## Serialize time state for save system.
func serialize() -> Dictionary:
	return {
		"current_hour": current_hour,
		"current_day": current_day,
		"is_night": is_night,
	}


## Deserialize time state from save data.
func deserialize(data: Dictionary) -> void:
	current_hour = float(data.get("current_hour", 6.0))
	current_day = int(data.get("current_day", 1))
	_last_whole_hour = int(current_hour)
	_update_night_flag()

	# Sync day_number in GameManager.
	GameManager.day_number = current_day

	# Emit signals so UI updates.
	hour_changed.emit(int(current_hour))
	day_changed.emit(current_day)
	if is_night:
		night_started.emit()
	else:
		day_started.emit()
