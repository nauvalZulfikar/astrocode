## RobotManager — Fleet management singleton for AstroCode.
## Manages robot database, spawning, power drain, and active robot tracking.
extends Node

# --- Signals ---
signal robot_built(robot: Node2D)
signal robot_destroyed(robot: Node2D)

# --- Config ---
const MAX_FLEET_SIZE: int = 12
## Power drain per active robot, in power units per real-time minute.
const POWER_DRAIN_PER_ROBOT: float = 2.0

# --- Robot database ---
## Key = robot type id, value = spec dictionary.
const ROBOT_DB: Dictionary = {
	"scuttle": {
		"id": "scuttle",
		"name": "Scuttle",
		"unlock_day": 4,
		"build_cost": {
			"scrap_metal": 8,
			"circuit_board": 2,
			"battery": 1,
			"motor": 1,
		},
		"battery_life": 45.0,
		"max_cargo": 6,
		"sensor_slots": 1,
		"speed": 40.0,
		"special": "Auto-harvest: gathers tagged resource nodes",
		"color": Color(0.6, 0.6, 0.6),
	},
	"ohm": {
		"id": "ohm",
		"name": "Ohm",
		"unlock_day": 12,
		"build_cost": {
			"iron_ore": 4,
			"circuit_board": 3,
			"sensor_module": 2,
			"battery": 1,
		},
		"battery_life": 60.0,
		"max_cargo": 2,
		"sensor_slots": 4,
		"speed": 30.0,
		"special": "Sensor fusion: combines readings from all slots into unified data stream",
		"color": Color(0.3, 0.6, 0.8),
	},
	"welder": {
		"id": "welder",
		"name": "Welder",
		"unlock_day": 16,
		"build_cost": {
			"iron_ore": 10,
			"circuit_board": 3,
			"motor": 2,
			"battery": 1,
		},
		"battery_life": 40.0,
		"max_cargo": 4,
		"sensor_slots": 1,
		"speed": 30.0,
		"special": "Place & repair: can build structures from blueprints and repair damaged ones",
		"color": Color(0.9, 0.5, 0.2),
	},
	"plow": {
		"id": "plow",
		"name": "Plow",
		"unlock_day": 18,
		"build_cost": {
			"scrap_metal": 6,
			"circuit_board": 2,
			"motor": 1,
			"sensor_module": 1,
			"battery": 1,
		},
		"battery_life": 50.0,
		"max_cargo": 4,
		"sensor_slots": 2,
		"speed": 35.0,
		"special": "Till & tend: plants, waters, and harvests bio-crops automatically",
		"color": Color(0.35, 0.6, 0.25),
	},
	"drift": {
		"id": "drift",
		"name": "Drift",
		"unlock_day": 14,
		"build_cost": {
			"scrap_metal": 4,
			"circuit_board": 2,
			"sensor_module": 2,
			"battery": 1,
		},
		"battery_life": 35.0,
		"max_cargo": 2,
		"sensor_slots": 3,
		"speed": 80.0,
		"special": "Fast move: 2x speed, reveals fog of war, auto-maps terrain",
		"color": Color(0.5, 0.8, 0.9),
	},
	"mule": {
		"id": "mule",
		"name": "Mule",
		"unlock_day": 26,
		"build_cost": {
			"iron_ore": 12,
			"circuit_board": 2,
			"motor": 2,
			"battery": 2,
		},
		"battery_life": 30.0,
		"max_cargo": 16,
		"sensor_slots": 1,
		"speed": 25.0,
		"special": "Heavy lift: can carry structures and bulk resources between bases",
		"color": Color(0.55, 0.3, 0.2),
	},
	"pip": {
		"id": "pip",
		"name": "Pip",
		"unlock_day": 30,
		"build_cost": {
			"scrap_metal": 2,
			"circuit_board": 1,
			"microcontroller": 1,
		},
		"battery_life": 20.0,
		"max_cargo": 0,
		"sensor_slots": 1,
		"speed": 45.0,
		"special": "Mesh network: shares sensor data with all Pips in range (8 tiles)",
		"color": Color(0.9, 0.85, 0.2),
	},
	"atlas": {
		"id": "atlas",
		"name": "Atlas",
		"unlock_day": 42,
		"build_cost": {
			"rare_earth_metals": 6,
			"microcontroller": 2,
			"sensor_module": 3,
			"motor": 2,
			"neural_core": 1,
			"battery": 2,
		},
		"battery_life": 90.0,
		"max_cargo": 8,
		"sensor_slots": 4,
		"speed": 35.0,
		"special": "AI-capable: can run decision trees and neural nets locally",
		"color": Color(0.6, 0.3, 0.9),
	},
}

# --- State ---
var active_robots: Array[Node2D] = []

# Preloaded robot scene.
var _robot_scene: PackedScene = preload("res://scenes/robots/robot_base.tscn")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


## Check whether a robot of [robot_type] can be built right now.
## Verifies unlock day, fleet capacity, and material availability.
func can_build(robot_type: String) -> bool:
	if not ROBOT_DB.has(robot_type):
		push_warning("RobotManager: Unknown robot type '%s'" % robot_type)
		return false

	var spec: Dictionary = ROBOT_DB[robot_type]

	# Check unlock day.
	if GameManager.day_number < spec["unlock_day"]:
		return false

	# Check fleet capacity.
	if active_robots.size() >= MAX_FLEET_SIZE:
		return false

	# Check materials.
	var cost: Dictionary = spec["build_cost"]
	for item_id: String in cost:
		if not InventoryManager.has_item(item_id, cost[item_id]):
			return false

	return true


## Build a robot of [robot_type] at [spawn_pos].
## Consumes materials from inventory. Returns the spawned Node2D or null on failure.
func build_robot(robot_type: String, spawn_pos: Vector2) -> Node2D:
	if not can_build(robot_type):
		return null

	var spec: Dictionary = ROBOT_DB[robot_type]

	# Consume materials.
	var cost: Dictionary = spec["build_cost"]
	for item_id: String in cost:
		InventoryManager.remove_item(item_id, cost[item_id])

	# Spawn the robot.
	var robot: Node2D = _robot_scene.instantiate()
	robot.robot_type = robot_type
	robot.robot_name = spec["name"]
	robot.position = spawn_pos

	# Configure stats from spec.
	robot.battery_max = spec["battery_life"]
	robot.battery_current = spec["battery_life"]
	robot.max_cargo = spec["max_cargo"]
	robot.move_speed = spec["speed"]

	# Add to the world (current scene tree root).
	var world: Node = get_tree().current_scene
	if world:
		world.add_child(robot)

	# Track it.
	active_robots.append(robot)
	robot.tree_exiting.connect(_on_robot_removed.bind(robot))

	robot_built.emit(robot)
	return robot


## Get the number of active robots.
func get_active_count() -> int:
	return active_robots.size()


## Find an active robot by its display name (case-sensitive).
func get_robot_by_name(rname: String) -> Node2D:
	for robot: Node2D in active_robots:
		if is_instance_valid(robot) and robot.robot_name == rname:
			return robot
	return null


## Return a copy of the active robots array.
func get_all_robots() -> Array:
	return active_robots.duplicate()


## Get the spec dictionary for a robot type.
func get_robot_spec(robot_type: String) -> Dictionary:
	if ROBOT_DB.has(robot_type):
		return ROBOT_DB[robot_type]
	return {}


## Total power drain from all active robots (power units per real-time minute).
func get_total_power_drain() -> float:
	return float(active_robots.size()) * POWER_DRAIN_PER_ROBOT


## Called when a robot exits the scene tree (destroyed or freed).
func _on_robot_removed(robot: Node2D) -> void:
	active_robots.erase(robot)
	robot_destroyed.emit(robot)


## Serialize all active robots for save system.
func serialize() -> Array:
	var result: Array = []
	for robot: Node2D in active_robots:
		if not is_instance_valid(robot):
			continue
		var robot_data: Dictionary = {
			"type": robot.robot_type,
			"name": robot.robot_name,
			"position": {"x": robot.global_position.x, "y": robot.global_position.y},
			"battery": robot.battery_current,
			"cargo": [],
			"status": robot.status,
		}
		# Serialize cargo.
		for item: Dictionary in robot.cargo:
			robot_data["cargo"].append({
				"id": item.get("id", ""),
				"count": item.get("count", 0),
			})
		result.append(robot_data)
	return result


## Deserialize robots from save data. Removes existing robots and spawns new ones.
func deserialize(data: Array) -> void:
	# Remove all existing robots.
	for robot: Node2D in active_robots.duplicate():
		if is_instance_valid(robot):
			robot.queue_free()
	active_robots.clear()

	# Spawn robots from save data.
	var world: Node = get_tree().current_scene
	if world == null:
		push_warning("RobotManager: No current scene to spawn robots into")
		return

	for entry: Variant in data:
		if not entry is Dictionary:
			continue
		var robot_data: Dictionary = entry as Dictionary

		var rtype: String = str(robot_data.get("type", ""))
		if rtype == "" or not ROBOT_DB.has(rtype):
			push_warning("RobotManager: Skipping unknown robot type '%s' from save" % rtype)
			continue

		var spec: Dictionary = ROBOT_DB[rtype]
		var robot: Node2D = _robot_scene.instantiate()
		robot.robot_type = rtype
		robot.robot_name = str(robot_data.get("name", spec["name"]))

		# Position.
		if robot_data.has("position") and robot_data["position"] is Dictionary:
			var pos: Dictionary = robot_data["position"] as Dictionary
			robot.position = Vector2(float(pos.get("x", 0.0)), float(pos.get("y", 0.0)))

		# Stats from spec + saved battery.
		robot.battery_max = spec["battery_life"]
		robot.battery_current = float(robot_data.get("battery", spec["battery_life"]))
		robot.max_cargo = spec["max_cargo"]
		robot.move_speed = spec["speed"]

		# Restore cargo.
		robot.cargo.clear()
		if robot_data.has("cargo") and robot_data["cargo"] is Array:
			for cargo_entry: Variant in robot_data["cargo"] as Array:
				if cargo_entry is Dictionary:
					var cd: Dictionary = cargo_entry as Dictionary
					robot.cargo.append({
						"id": str(cd.get("id", "")),
						"count": int(cd.get("count", 0)),
					})

		# Restore status.
		var saved_status: String = str(robot_data.get("status", "idle"))
		if saved_status == "shutdown":
			robot.status = "shutdown"
		else:
			robot.status = "idle"

		# Add to scene.
		world.add_child(robot)

		# Track it.
		active_robots.append(robot)
		robot.tree_exiting.connect(_on_robot_removed.bind(robot))
		robot_built.emit(robot)
