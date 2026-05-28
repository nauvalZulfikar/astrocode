## CircuitManager — Manages circuit builder logic, simulation, and puzzle validation.
## Grid-based breadboard: 12 columns x 8 rows.
## Row 0 = positive rail, Row 7 = negative rail.
extends Node

# --- Signals ---
signal circuit_simulated(circuit_id: int)
signal component_burned(circuit_id: int, col: int, row: int)
signal short_circuit(circuit_id: int)

# --- Constants ---
const GRID_COLS: int = 12
const GRID_ROWS: int = 8

# --- Component database ---
const COMPONENTS: Dictionary = {
	"wire": {"resistance": 0.001, "max_voltage": 100.0, "cost": {"copper_wire": 1}},
	"resistor_68": {"resistance": 68.0, "max_voltage": 12.0, "cost": {"salt_crystal": 1}},
	"resistor_100": {"resistance": 100.0, "max_voltage": 12.0, "cost": {"salt_crystal": 1}},
	"resistor_220": {"resistance": 220.0, "max_voltage": 12.0, "cost": {"salt_crystal": 1}},
	"led_red": {"resistance": 50.0, "max_voltage": 5.0, "forward_voltage": 1.8, "cost": {"copper_wire": 1}},
	"led_green": {"resistance": 50.0, "max_voltage": 5.0, "forward_voltage": 2.0, "cost": {"copper_wire": 1}},
	"battery_3v": {"voltage": 3.0, "is_source": true, "cost": {"battery": 1}},
}

# --- Internal storage ---
## Key = circuit_id, Value = circuit data Dictionary.
var _circuits: Dictionary = {}
var _next_id: int = 1


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


# =============================================================================
# Public API
# =============================================================================

## Create a new empty circuit. Returns the circuit_id.
func create_circuit() -> int:
	var id: int = _next_id
	_next_id += 1

	_circuits[id] = {
		"grid": _make_empty_grid(),
		"wires": [],            # Array of {from_col, from_row, to_col, to_row}
		"last_result": {},
	}
	return id


## Place a component on the grid. Returns false if cell is occupied or invalid.
func place_component(circuit_id: int, comp_type: String, col: int, row: int) -> bool:
	if not _circuits.has(circuit_id):
		return false
	if not COMPONENTS.has(comp_type):
		return false
	if not _in_bounds(col, row):
		return false

	var grid: Array = _circuits[circuit_id]["grid"]
	if grid[row][col] != "":
		return false  # Cell occupied.

	grid[row][col] = comp_type
	return true


## Remove a component from a grid cell.
func remove_component(circuit_id: int, col: int, row: int) -> void:
	if not _circuits.has(circuit_id):
		return
	if not _in_bounds(col, row):
		return

	var grid: Array = _circuits[circuit_id]["grid"]
	var comp_type: String = grid[row][col]
	grid[row][col] = ""

	# Also remove any wires connected to this cell.
	if comp_type != "":
		_remove_wires_at(circuit_id, col, row)


## Add a wire between two adjacent cells. Returns false if not adjacent or invalid.
func add_wire(circuit_id: int, from_col: int, from_row: int, to_col: int, to_row: int) -> bool:
	if not _circuits.has(circuit_id):
		return false
	if not _in_bounds(from_col, from_row) or not _in_bounds(to_col, to_row):
		return false

	# Must be adjacent (4-connected: up/down/left/right).
	var dc: int = absi(to_col - from_col)
	var dr: int = absi(to_row - from_row)
	if (dc + dr) != 1:
		return false

	# Check for duplicate wire.
	var wires: Array = _circuits[circuit_id]["wires"]
	for w: Dictionary in wires:
		if _wire_matches(w, from_col, from_row, to_col, to_row):
			return false  # Already exists.

	wires.append({
		"from_col": from_col,
		"from_row": from_row,
		"to_col": to_col,
		"to_row": to_row,
	})
	return true


## Run circuit simulation. Returns a result dictionary.
func simulate(circuit_id: int) -> Dictionary:
	if not _circuits.has(circuit_id):
		return {"valid": false, "components_state": [], "total_current": 0.0, "errors": ["Circuit not found"]}

	var circuit: Dictionary = _circuits[circuit_id]
	var grid: Array = circuit["grid"]
	var wires: Array = circuit["wires"]

	# --- Step 1: Find all batteries ---
	var batteries: Array[Dictionary] = []
	for r: int in range(GRID_ROWS):
		for c: int in range(GRID_COLS):
			var comp: String = grid[r][c]
			if comp != "" and COMPONENTS.has(comp) and COMPONENTS[comp].get("is_source", false):
				batteries.append({"col": c, "row": r, "type": comp})

	if batteries.is_empty():
		var result: Dictionary = {"valid": false, "components_state": [], "total_current": 0.0, "errors": ["No battery found"]}
		circuit["last_result"] = result
		return result

	# --- Step 2: Build adjacency graph ---
	var adj: Dictionary = _build_adjacency(grid, wires)

	# --- Step 3: Find all paths from positive rail (row 0) to negative rail (row 7) ---
	# For simplicity: find paths from each battery to the negative rail.
	var all_paths: Array[Array] = []
	var errors: Array[String] = []

	for bat: Dictionary in batteries:
		var bat_key: String = _cell_key(bat["col"], bat["row"])
		# Find paths from battery to any cell on row 7 (negative rail).
		var paths: Array[Array] = _find_all_paths(adj, bat_key, grid)
		all_paths.append_array(paths)

	# --- Step 4: Calculate currents and voltage drops for each path ---
	var components_state: Array[Dictionary] = []
	var total_current: float = 0.0
	var has_short: bool = false
	var burned: Array[Dictionary] = []

	# Track component state by cell key to merge parallel paths.
	var cell_state: Dictionary = {}

	for path: Array in all_paths:
		# Get the battery voltage for this path.
		var path_voltage: float = _get_path_voltage(path, grid)

		# Sum total resistance along the path.
		var path_resistance: float = _get_path_resistance(path, grid)

		# Short circuit check.
		if path_resistance < 1.0:
			has_short = true
			errors.append("Short circuit! Total resistance %.3f ohm" % path_resistance)
			short_circuit.emit(circuit_id)
			continue

		# Calculate current: I = V / R.
		var current: float = path_voltage / path_resistance
		total_current += current

		# Calculate voltage drop for each component in the path.
		for cell_key: String in path:
			var coords: Vector2i = _key_to_cell(cell_key)
			var comp_type: String = grid[coords.y][coords.x]

			if comp_type == "" or not COMPONENTS.has(comp_type):
				continue
			if COMPONENTS[comp_type].get("is_source", false):
				continue  # Skip battery itself.

			var comp_data: Dictionary = COMPONENTS[comp_type]
			var resistance: float = comp_data["resistance"]
			var voltage_drop: float = current * resistance
			var max_v: float = comp_data["max_voltage"]

			var is_burned: bool = voltage_drop > max_v
			var is_lit: bool = false

			# LED check: lit if current > 0 and not burned.
			if comp_type.begins_with("led_"):
				is_lit = current > 0.0 and not is_burned

			if is_burned:
				burned.append({"col": coords.x, "row": coords.y})
				errors.append("%s at (%d,%d) burned! %.2fV > %.2fV max" % [comp_type, coords.x, coords.y, voltage_drop, max_v])
				component_burned.emit(circuit_id, coords.x, coords.y)

			# Store or merge state.
			if not cell_state.has(cell_key):
				cell_state[cell_key] = {
					"col": coords.x,
					"row": coords.y,
					"type": comp_type,
					"current": current,
					"voltage_drop": voltage_drop,
					"is_lit": is_lit,
					"is_burned": is_burned,
				}
			else:
				# Parallel: currents add.
				cell_state[cell_key]["current"] += current
				if is_lit:
					cell_state[cell_key]["is_lit"] = true
				if is_burned:
					cell_state[cell_key]["is_burned"] = true

	for key: String in cell_state:
		components_state.append(cell_state[key])

	var valid: bool = errors.is_empty() and not all_paths.is_empty()

	var result: Dictionary = {
		"valid": valid,
		"components_state": components_state,
		"total_current": total_current,
		"errors": errors,
		"has_short": has_short,
	}

	circuit["last_result"] = result
	circuit_simulated.emit(circuit_id)
	return result


## Clear all components and wires from a circuit.
func clear_circuit(circuit_id: int) -> void:
	if not _circuits.has(circuit_id):
		return
	_circuits[circuit_id]["grid"] = _make_empty_grid()
	_circuits[circuit_id]["wires"].clear()
	_circuits[circuit_id]["last_result"] = {}


## Get all placed components in a circuit.
func get_components(circuit_id: int) -> Array:
	if not _circuits.has(circuit_id):
		return []

	var result: Array = []
	var grid: Array = _circuits[circuit_id]["grid"]
	for r: int in range(GRID_ROWS):
		for c: int in range(GRID_COLS):
			if grid[r][c] != "":
				result.append({"col": c, "row": r, "type": grid[r][c]})
	return result


## Get all wires in a circuit.
func get_wires(circuit_id: int) -> Array:
	if not _circuits.has(circuit_id):
		return []
	return _circuits[circuit_id]["wires"].duplicate()


## Get the raw grid for a circuit.
func get_grid(circuit_id: int) -> Array:
	if not _circuits.has(circuit_id):
		return []
	return _circuits[circuit_id]["grid"]


## Get the last simulation result for a circuit.
func get_last_result(circuit_id: int) -> Dictionary:
	if not _circuits.has(circuit_id):
		return {}
	return _circuits[circuit_id].get("last_result", {})


## Validate a circuit against a puzzle definition.
func validate_puzzle(circuit_id: int, puzzle_id: String) -> Dictionary:
	var sim: Dictionary = simulate(circuit_id)

	match puzzle_id:
		"circuit_led_basic":
			return _validate_led_basic(sim)
		"circuit_resistor":
			return _validate_resistor(sim)
		"circuit_parallel_3led":
			return _validate_parallel_3led(sim)
		"circuit_voltage_divider":
			return _validate_voltage_divider(sim)
		_:
			return {"passed": false, "message": "Unknown puzzle: %s" % puzzle_id}


## Check if the player can afford a component's material cost.
func can_afford_component(comp_type: String) -> bool:
	if not COMPONENTS.has(comp_type):
		return false
	var cost: Dictionary = COMPONENTS[comp_type]["cost"]
	for item_id: String in cost:
		if not InventoryManager.has_item(item_id, cost[item_id]):
			return false
	return true


## Consume materials for placing a component. Returns false if cannot afford.
func consume_component_cost(comp_type: String) -> bool:
	if not can_afford_component(comp_type):
		return false
	var cost: Dictionary = COMPONENTS[comp_type]["cost"]
	for item_id: String in cost:
		InventoryManager.remove_item(item_id, cost[item_id])
	return true


## Delete a circuit entirely.
func delete_circuit(circuit_id: int) -> void:
	_circuits.erase(circuit_id)


## Serialize all circuits for save system.
func serialize() -> Dictionary:
	var data: Dictionary = {}
	for id: int in _circuits:
		var circuit: Dictionary = _circuits[id]
		data[str(id)] = {
			"grid": _serialize_grid(circuit["grid"]),
			"wires": circuit["wires"].duplicate(true),
		}
	return {"circuits": data, "next_id": _next_id}


## Deserialize circuits from save data.
func deserialize(data: Dictionary) -> void:
	_circuits.clear()
	if not data.has("circuits"):
		return
	_next_id = int(data.get("next_id", 1))
	var circuits_data: Dictionary = data["circuits"] as Dictionary
	for id_str: String in circuits_data:
		var id: int = int(id_str)
		var entry: Dictionary = circuits_data[id_str] as Dictionary
		_circuits[id] = {
			"grid": _deserialize_grid(entry.get("grid", [])),
			"wires": entry.get("wires", []).duplicate(true),
			"last_result": {},
		}


# =============================================================================
# Private helpers
# =============================================================================

## Create an empty 8x12 grid (Array of Array of String).
func _make_empty_grid() -> Array:
	var grid: Array = []
	for r: int in range(GRID_ROWS):
		var row: Array = []
		row.resize(GRID_COLS)
		row.fill("")
		grid.append(row)
	return grid


## Check if col/row are within grid bounds.
func _in_bounds(col: int, row: int) -> bool:
	return col >= 0 and col < GRID_COLS and row >= 0 and row < GRID_ROWS


## Create a unique string key for a cell.
func _cell_key(col: int, row: int) -> String:
	return "%d,%d" % [col, row]


## Parse a cell key back to coordinates.
func _key_to_cell(key: String) -> Vector2i:
	var parts: PackedStringArray = key.split(",")
	return Vector2i(int(parts[0]), int(parts[1]))


## Check if a wire definition matches the given endpoints (either direction).
func _wire_matches(w: Dictionary, fc: int, fr: int, tc: int, tr: int) -> bool:
	return (w["from_col"] == fc and w["from_row"] == fr and w["to_col"] == tc and w["to_row"] == tr) \
		or (w["from_col"] == tc and w["from_row"] == tr and w["to_col"] == fc and w["to_row"] == fr)


## Remove all wires connected to a cell.
func _remove_wires_at(circuit_id: int, col: int, row: int) -> void:
	var wires: Array = _circuits[circuit_id]["wires"]
	for i: int in range(wires.size() - 1, -1, -1):
		var w: Dictionary = wires[i]
		if (w["from_col"] == col and w["from_row"] == row) \
				or (w["to_col"] == col and w["to_row"] == row):
			wires.remove_at(i)


## Build an adjacency dictionary from grid components and wires.
## Key = cell_key, Value = Array of adjacent cell_keys.
func _build_adjacency(grid: Array, wires: Array) -> Dictionary:
	var adj: Dictionary = {}

	# Add wire connections.
	for w: Dictionary in wires:
		var a: String = _cell_key(w["from_col"], w["from_row"])
		var b: String = _cell_key(w["to_col"], w["to_row"])
		if not adj.has(a):
			adj[a] = []
		if not adj.has(b):
			adj[b] = []
		if b not in adj[a]:
			adj[a].append(b)
		if a not in adj[b]:
			adj[b].append(a)

	# Components implicitly connect to adjacent occupied cells or wired cells,
	# but only through explicit wires. No implicit adjacency beyond wires.

	return adj


## Find all paths from a start cell to any cell on row 7 (negative rail).
## Uses DFS with visited tracking to avoid cycles.
func _find_all_paths(adj: Dictionary, start: String, grid: Array) -> Array[Array]:
	var paths: Array[Array] = []
	var visited: Dictionary = {}
	var current_path: Array = []
	_dfs_paths(adj, start, grid, visited, current_path, paths)
	return paths


## DFS recursive helper for path finding.
func _dfs_paths(adj: Dictionary, current: String, grid: Array,
		visited: Dictionary, path: Array, results: Array[Array]) -> void:
	visited[current] = true
	path.append(current)

	# Check if we reached the negative rail (row 7).
	var coords: Vector2i = _key_to_cell(current)
	if coords.y == GRID_ROWS - 1:
		results.append(path.duplicate())
	elif adj.has(current):
		for neighbor: String in adj[current]:
			if not visited.has(neighbor):
				_dfs_paths(adj, neighbor, grid, visited, path, results)

	path.pop_back()
	visited.erase(current)


## Get the total voltage supplied by batteries in a path.
func _get_path_voltage(path: Array, grid: Array) -> float:
	var total_v: float = 0.0
	for cell_key: String in path:
		var coords: Vector2i = _key_to_cell(cell_key)
		var comp: String = grid[coords.y][coords.x]
		if comp != "" and COMPONENTS.has(comp) and COMPONENTS[comp].get("is_source", false):
			total_v += COMPONENTS[comp]["voltage"]
	return total_v


## Get the total resistance of all non-source components in a path.
func _get_path_resistance(path: Array, grid: Array) -> float:
	var total_r: float = 0.0
	for cell_key: String in path:
		var coords: Vector2i = _key_to_cell(cell_key)
		var comp: String = grid[coords.y][coords.x]
		if comp == "":
			# Empty cell used as wire junction — add tiny wire resistance.
			total_r += 0.001
		elif COMPONENTS.has(comp):
			if not COMPONENTS[comp].get("is_source", false):
				total_r += COMPONENTS[comp]["resistance"]
		# else unknown component — skip.
	return total_r


## Serialize a grid to a flat array for saving.
func _serialize_grid(grid: Array) -> Array:
	var flat: Array = []
	for row: Array in grid:
		flat.append(row.duplicate())
	return flat


## Deserialize a grid from a flat array.
func _deserialize_grid(flat: Array) -> Array:
	if flat.is_empty():
		return _make_empty_grid()
	var grid: Array = []
	for row_data: Variant in flat:
		if row_data is Array:
			grid.append((row_data as Array).duplicate())
		else:
			var empty_row: Array = []
			empty_row.resize(GRID_COLS)
			empty_row.fill("")
			grid.append(empty_row)
	# Ensure correct size.
	while grid.size() < GRID_ROWS:
		var empty_row: Array = []
		empty_row.resize(GRID_COLS)
		empty_row.fill("")
		grid.append(empty_row)
	return grid


# =============================================================================
# Puzzle validators
# =============================================================================

## Puzzle 1: Battery + LED connected, LED lit, not burned.
func _validate_led_basic(sim: Dictionary) -> Dictionary:
	if sim.get("has_short", false):
		return {"passed": false, "message": "Short circuit detected! Add a resistor to protect the LED."}

	var states: Array = sim.get("components_state", [])
	var led_found: bool = false
	var led_lit: bool = false
	var led_burned: bool = false

	for comp: Dictionary in states:
		var comp_type: String = comp.get("type", "")
		if comp_type.begins_with("led_"):
			led_found = true
			if comp.get("is_lit", false):
				led_lit = true
			if comp.get("is_burned", false):
				led_burned = true

	if not led_found:
		return {"passed": false, "message": "No LED found in circuit. Place an LED on the breadboard."}
	if led_burned:
		return {"passed": false, "message": "LED burned out! Use a resistor to limit current."}
	if not led_lit:
		return {"passed": false, "message": "LED not lit. Check your wiring — connect battery to LED to ground rail."}

	return {"passed": true, "message": "LED is lit! Circuit complete."}


## Puzzle 2: Battery + resistor + LED, LED lit, voltage_drop on LED < 5V.
func _validate_resistor(sim: Dictionary) -> Dictionary:
	if sim.get("has_short", false):
		return {"passed": false, "message": "Short circuit detected!"}

	var states: Array = sim.get("components_state", [])
	var has_resistor: bool = false
	var led_lit: bool = false
	var led_burned: bool = false
	var led_vdrop: float = 0.0

	for comp: Dictionary in states:
		var comp_type: String = comp.get("type", "")
		if comp_type.begins_with("resistor_"):
			has_resistor = true
		if comp_type.begins_with("led_"):
			if comp.get("is_lit", false):
				led_lit = true
			if comp.get("is_burned", false):
				led_burned = true
			led_vdrop = comp.get("voltage_drop", 0.0)

	if not has_resistor:
		return {"passed": false, "message": "No resistor in circuit. Add a resistor to protect the LED."}
	if led_burned:
		return {"passed": false, "message": "LED burned out! Your resistor value is too low."}
	if not led_lit:
		return {"passed": false, "message": "LED not lit. Check wiring: battery -> resistor -> LED -> ground."}
	if led_vdrop >= 5.0:
		return {"passed": false, "message": "LED voltage drop too high (%.2fV). Use a higher-value resistor." % led_vdrop}

	return {"passed": true, "message": "Resistor-protected LED circuit works! Voltage drop: %.2fV" % led_vdrop}


## Puzzle 3: 3 LEDs in parallel, all lit.
func _validate_parallel_3led(sim: Dictionary) -> Dictionary:
	if sim.get("has_short", false):
		return {"passed": false, "message": "Short circuit detected!"}

	var states: Array = sim.get("components_state", [])
	var lit_count: int = 0
	var total_leds: int = 0
	var any_burned: bool = false

	for comp: Dictionary in states:
		var comp_type: String = comp.get("type", "")
		if comp_type.begins_with("led_"):
			total_leds += 1
			if comp.get("is_lit", false):
				lit_count += 1
			if comp.get("is_burned", false):
				any_burned = true

	if total_leds < 3:
		return {"passed": false, "message": "Need 3 LEDs in parallel. Found %d." % total_leds}
	if any_burned:
		return {"passed": false, "message": "One or more LEDs burned out! Add resistors."}
	if lit_count < 3:
		return {"passed": false, "message": "Only %d of 3 LEDs are lit. Check parallel wiring." % lit_count}

	return {"passed": true, "message": "All 3 LEDs lit in parallel! Well done."}


## Puzzle 4: Voltage divider — output between 1.4V and 1.6V.
func _validate_voltage_divider(sim: Dictionary) -> Dictionary:
	if sim.get("has_short", false):
		return {"passed": false, "message": "Short circuit detected!"}

	var states: Array = sim.get("components_state", [])
	var resistor_drops: Array[float] = []

	for comp: Dictionary in states:
		var comp_type: String = comp.get("type", "")
		if comp_type.begins_with("resistor_"):
			resistor_drops.append(comp.get("voltage_drop", 0.0))

	if resistor_drops.size() < 2:
		return {"passed": false, "message": "Need two resistors for a voltage divider. Found %d." % resistor_drops.size()}

	# The output voltage is the drop across the second resistor (lower one).
	# Sort drops — the smaller drop is the output.
	resistor_drops.sort()
	var output_v: float = resistor_drops[0]

	if output_v >= 1.4 and output_v <= 1.6:
		return {"passed": true, "message": "Voltage divider output: %.2fV. Perfect!" % output_v}
	else:
		return {"passed": false, "message": "Output voltage is %.2fV. Target: 1.4V - 1.6V. Adjust resistor values." % output_v}
