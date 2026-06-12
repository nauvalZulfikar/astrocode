## GameManager — Global state singleton for AstroCode.
## Manages player stats, biome state, death conditions, and script storage.
extends Node

# --- Signals ---
signal stat_changed(stat_name: String, new_value: float)
signal player_died(cause: String)
signal biome_changed(new_biome: String)

# --- State ---
var current_biome: String = "alkaline_flats"
var day_number: int = 1

## Saved AstroScript programs. Key = script name, value = source code string.
var saved_scripts: Dictionary = {}

## Saved circuit designs. Key = circuit name, value = circuit data Dictionary.
var saved_circuits: Dictionary = {}

## Player vital stats. All values clamped 0-100 except temperature.
var player_stats: Dictionary = {
	"health": 100.0,
	"oxygen": 100.0,
	"energy": 100.0,
	"hunger": 100.0,
	"temperature": 25.0,
}

# --- Internal timers ---
# Hunger depletes at 1 per 420 real seconds (7 real minutes = 7 in-game hours).
const HUNGER_DEPLETION_RATE: float = 1.0 / 420.0 # per real second

# Oxygen depletion per real second based on biome.
const O2_RATE_NORMAL: float = 1.0 / 60.0   # -1 per minute outdoors, breathable atmo
const O2_RATE_TOXIC: float = 3.0 / 60.0    # -3 per minute in toxic biomes
const O2_RATE_SEALED: float = 0.0           # inside sealed base

# Whether the player is inside a sealed room (set by base/room system).
var is_in_sealed_room: bool = false

# Biomes that count as toxic atmosphere.
const TOXIC_BIOMES: PackedStringArray = [
	"spore_marshes", "magma_veins", "polar_sink"
]

# --- Health regen ---
# Passive regen: 1 HP/min when hunger > 50%.
const HP_REGEN_RATE: float = 1.0 / 60.0

# Hunger-zero penalty: energy drains 3x faster, HP -1/min.
const HUNGER_ZERO_HP_DRAIN: float = 1.0 / 60.0
const HUNGER_ZERO_ENERGY_MULT: float = 3.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


## Modify a stat by [amount] (positive = increase, negative = decrease).
## Automatically clamps, emits signal, and checks death conditions.
func modify_stat(stat: String, amount: float) -> void:
	if not player_stats.has(stat):
		push_warning("GameManager: Unknown stat '%s'" % stat)
		return

	var old_value: float = player_stats[stat]
	var new_value: float = old_value + amount

	# Temperature is unclamped (environment-driven); all others 0-100.
	if stat != "temperature":
		new_value = clampf(new_value, 0.0, 100.0)

	player_stats[stat] = new_value

	if not is_equal_approx(old_value, new_value):
		stat_changed.emit(stat, new_value)

	# --- Death checks ---
	if stat == "health" and new_value <= 0.0:
		player_died.emit("health")
	elif stat == "oxygen" and new_value <= 0.0:
		player_died.emit("oxygen")


## Return the current value of a stat.
func get_stat(stat: String) -> float:
	if player_stats.has(stat):
		return player_stats[stat]
	push_warning("GameManager: Unknown stat '%s'" % stat)
	return 0.0


## Called every frame by TimeManager when time is ticking.
## [delta] is the real-time delta in seconds.
func tick_stats(delta: float) -> void:
	# --- Hunger depletion ---
	modify_stat("hunger", -HUNGER_DEPLETION_RATE * delta)

	# --- Oxygen ---
	if not is_in_sealed_room:
		var o2_rate: float = O2_RATE_NORMAL
		if current_biome in TOXIC_BIOMES:
			o2_rate = O2_RATE_TOXIC
		modify_stat("oxygen", -o2_rate * delta)

	# --- Hunger-zero penalties ---
	if player_stats["hunger"] <= 0.0:
		modify_stat("health", -HUNGER_ZERO_HP_DRAIN * delta)
		# (Energy drain multiplier is handled by whoever consumes energy.)

	# --- Passive HP regen ---
	if player_stats["hunger"] > 50.0 and player_stats["health"] < 100.0:
		modify_stat("health", HP_REGEN_RATE * delta)

	# --- Temperature damage ---
	var temp: float = player_stats["temperature"]
	if temp < 0.0:
		# Frostbite: 3 HP/min
		modify_stat("health", -(3.0 / 60.0) * delta)
	elif temp > 60.0:
		# Heatstroke: 5 HP/min
		modify_stat("health", -(5.0 / 60.0) * delta)


## Convenience: check if energy drain should be multiplied (hunger == 0).
func get_energy_drain_multiplier() -> float:
	if player_stats["hunger"] <= 0.0:
		return HUNGER_ZERO_ENERGY_MULT
	return 1.0


## Change the current biome and emit the biome_changed signal.
func set_biome(new_biome: String) -> void:
	if new_biome != current_biome:
		current_biome = new_biome
		biome_changed.emit(new_biome)


## Save an AstroScript program to the virtual filesystem.
func save_script(script_name: String, source: String) -> void:
	saved_scripts[script_name] = source


## Load an AstroScript program by name. Returns empty string if not found.
func load_script(script_name: String) -> String:
	if saved_scripts.has(script_name):
		return saved_scripts[script_name]
	return ""


## Save a circuit design by name.
func save_circuit(circuit_name: String, data: Dictionary) -> void:
	saved_circuits[circuit_name] = data


## Load a circuit design by name. Returns empty Dictionary if not found.
func load_circuit(circuit_name: String) -> Dictionary:
	if saved_circuits.has(circuit_name):
		return saved_circuits[circuit_name]
	return {}


## Get a sorted list of all saved circuit names.
func get_circuit_list() -> Array[String]:
	var names: Array[String] = []
	for key: String in saved_circuits:
		names.append(key)
	names.sort()
	return names


## Get a sorted list of all saved script names.
func get_script_list() -> Array[String]:
	var names: Array[String] = []
	for key: String in saved_scripts:
		names.append(key)
	names.sort()
	return names


## Serialize player stats, scripts, and circuits for save system.
func serialize() -> Dictionary:
	return {
		"stats": player_stats.duplicate(),
		"scripts": saved_scripts.duplicate(),
		"circuits": saved_circuits.duplicate(true),
	}


## Deserialize player stats and scripts from save data.
func deserialize(data: Dictionary) -> void:
	# Support both old format (flat stats dict) and new format (nested).
	var stats_data: Dictionary = data
	if data.has("stats") and data["stats"] is Dictionary:
		stats_data = data["stats"] as Dictionary
	for key: String in player_stats:
		if stats_data.has(key):
			player_stats[key] = float(stats_data[key])
	# Emit signals so UI updates.
	for key: String in player_stats:
		stat_changed.emit(key, player_stats[key])
	# Restore scripts.
	if data.has("scripts") and data["scripts"] is Dictionary:
		saved_scripts = (data["scripts"] as Dictionary).duplicate()
	else:
		saved_scripts = {}
	# Restore circuits.
	if data.has("circuits") and data["circuits"] is Dictionary:
		saved_circuits = (data["circuits"] as Dictionary).duplicate(true)
	else:
		saved_circuits = {}
