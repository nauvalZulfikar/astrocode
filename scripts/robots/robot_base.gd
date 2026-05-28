## RobotBase — Base class for all AstroCode robots.
## Handles movement, battery, cargo, task queue, and status display.
class_name RobotBase
extends CharacterBody2D

# --- Signals ---
signal battery_depleted()
signal task_completed(task: Dictionary)
signal cargo_full()

# --- Exports ---
@export var robot_type: String = "scuttle"
@export var robot_name: String = "Scuttle"

# --- Stats ---
var battery_current: float = 45.0
var battery_max: float = 45.0
var max_cargo: int = 6
var move_speed: float = 40.0

## Current cargo contents. Each entry: {id: String, count: int}
var cargo: Array[Dictionary] = []

## Robot status: "idle", "working", "moving", "error", "shutdown"
var status: String = "idle"

# --- Task queue ---
## Each task: {type: String, ...params}
## Supported types: "move_to", "gather", "deposit"
var task_queue: Array[Dictionary] = []

# --- Internal ---
var _move_target: Vector2 = Vector2.ZERO
var _is_moving: bool = false
var _gather_target: Node2D = null
var _gather_timer: float = 0.0
var _is_gathering: bool = false

## Battery depletion: battery_max is in minutes, so drain = 1 unit per real second * (max/max) = max/(max*60).
## Simplified: battery drains at battery_max / (battery_max * 60) = 1/60 per second.
## That means the battery fully depletes in battery_max * 60 real seconds = battery_max real minutes.
const BATTERY_DRAIN_PER_SEC: float = 1.0 / 60.0  # 1 unit per real minute

# --- Node references (set after _ready) ---
var _sprite: ColorRect = null
var _status_icon: ColorRect = null
var _battery_timer: Timer = null
var _interaction_area: Area2D = null

# --- Status icon colors ---
const STATUS_COLOR_RUNNING: Color = Color(0.2, 0.9, 0.2)      # Green
const STATUS_COLOR_IDLE: Color = Color(0.5, 0.5, 0.5)          # Grey
const STATUS_COLOR_LOW_BATTERY: Color = Color(0.9, 0.2, 0.2)   # Red
const STATUS_COLOR_SHUTDOWN: Color = Color(0.3, 0.3, 0.3)      # Dark grey


func _ready() -> void:
	# Cache node references.
	_sprite = $Sprite as ColorRect
	_status_icon = $StatusIcon as ColorRect
	_battery_timer = $BatteryTimer as Timer
	_interaction_area = $InteractionArea as Area2D

	# Set the sprite color based on robot type.
	if RobotManager.ROBOT_DB.has(robot_type):
		_sprite.color = RobotManager.ROBOT_DB[robot_type]["color"]

	# Connect battery timer.
	_battery_timer.timeout.connect(_on_battery_tick)
	_battery_timer.start()

	# Add to robot group for easy lookup.
	add_to_group("robots")

	# Initial status icon.
	_update_status_icon()


func _physics_process(delta: float) -> void:
	if status == "shutdown":
		return

	# Process movement.
	if _is_moving:
		_process_movement(delta)

	# Process gathering.
	if _is_gathering:
		_process_gathering(delta)

	# Process task queue when idle.
	if status == "idle" and not task_queue.is_empty():
		_execute_next_task()


## Move toward a target position.
func move_to(target: Vector2) -> void:
	if status == "shutdown":
		return
	_move_target = target
	_is_moving = true
	status = "moving"
	_update_status_icon()


## Start gathering a resource (if near a resource node).
func gather(resource_id: String) -> void:
	if status == "shutdown":
		return
	if _get_cargo_count() >= max_cargo:
		cargo_full.emit()
		return

	# Find nearest resource node of this type.
	var nodes: Array[Node] = get_tree().get_nodes_in_group("resources")
	var closest: Node2D = null
	var closest_dist: float = INF
	for node: Node in nodes:
		var rnode: Node2D = node as Node2D
		if rnode and is_instance_valid(rnode) and rnode.has_method("start_gather"):
			if rnode.resource_id == resource_id:
				var dist: float = global_position.distance_to(rnode.global_position)
				if dist < closest_dist:
					closest_dist = dist
					closest = rnode
	if closest and closest_dist < 24.0:
		# Close enough to gather.
		_start_robot_gather(closest)
	elif closest:
		# Need to move there first, then gather.
		assign_task({"type": "move_to", "target_x": closest.global_position.x, "target_y": closest.global_position.y})
		assign_task({"type": "gather", "resource_id": resource_id})
	else:
		status = "error"
		_update_status_icon()


## Return to base (origin) and deposit cargo to inventory.
func deposit() -> void:
	if status == "shutdown":
		return
	assign_task({"type": "move_to", "target_x": 0.0, "target_y": 0.0})
	assign_task({"type": "deposit"})


## Get a status dictionary for UI display.
func get_status() -> Dictionary:
	return {
		"battery": battery_current,
		"battery_max": battery_max,
		"cargo": cargo.duplicate(true),
		"cargo_count": _get_cargo_count(),
		"max_cargo": max_cargo,
		"position": global_position,
		"status": status,
		"robot_type": robot_type,
		"robot_name": robot_name,
		"task_queue_size": task_queue.size(),
	}


## Add a task to the task queue.
func assign_task(task: Dictionary) -> void:
	if status == "shutdown":
		return
	task_queue.append(task)


## Shut down the robot. Stops all activity.
func shutdown() -> void:
	status = "shutdown"
	_is_moving = false
	_is_gathering = false
	_gather_target = null
	task_queue.clear()
	velocity = Vector2.ZERO
	_update_status_icon()


## Boot up the robot from shutdown state.
func boot_up() -> void:
	if battery_current <= 0.0:
		return  # Cannot boot without battery.
	status = "idle"
	_update_status_icon()


## Get the interaction prompt for the HUD.
func get_interact_prompt() -> String:
	return "Press E to open %s" % robot_name


# --- Internal ---

## Process movement toward the target position.
func _process_movement(delta: float) -> void:
	var direction: Vector2 = _move_target - global_position
	var distance: float = direction.length()

	if distance < 2.0:
		# Arrived at target.
		_is_moving = false
		velocity = Vector2.ZERO
		status = "idle"
		_update_status_icon()
		return

	velocity = direction.normalized() * move_speed
	move_and_slide()


## Process a timed gather action.
func _process_gathering(delta: float) -> void:
	_gather_timer -= delta
	if _gather_timer <= 0.0:
		_is_gathering = false
		_finish_robot_gather()


## Start gathering from a resource node.
func _start_robot_gather(target: Node2D) -> void:
	_gather_target = target
	_gather_timer = _get_gather_time()
	_is_gathering = true
	status = "working"
	_update_status_icon()


## Finish gathering — add resource to cargo.
func _finish_robot_gather() -> void:
	if not is_instance_valid(_gather_target):
		status = "idle"
		_update_status_icon()
		return

	var resource_id: String = _gather_target.resource_id
	var count: int = _gather_target.resource_count

	# Clamp to remaining cargo space.
	var space: int = max_cargo - _get_cargo_count()
	count = mini(count, space)

	if count > 0:
		cargo.append({"id": resource_id, "count": count})
		_gather_target.queue_free()

	if _get_cargo_count() >= max_cargo:
		cargo_full.emit()

	_gather_target = null
	status = "idle"
	_update_status_icon()


## Get gather time (can be overridden by subclasses).
func _get_gather_time() -> float:
	return 1.5


## Execute the next task in the queue.
func _execute_next_task() -> void:
	if task_queue.is_empty():
		return

	var task: Dictionary = task_queue.pop_front()
	match task["type"]:
		"move_to":
			var target: Vector2 = Vector2(task["target_x"], task["target_y"])
			_move_target = target
			_is_moving = true
			status = "moving"
			_update_status_icon()
		"gather":
			gather(task.get("resource_id", ""))
		"deposit":
			_do_deposit()
		_:
			push_warning("RobotBase: Unknown task type '%s'" % task["type"])

	task_completed.emit(task)


## Deposit all cargo into the player's inventory.
func _do_deposit() -> void:
	status = "working"
	_update_status_icon()

	for item: Dictionary in cargo:
		InventoryManager.add_item(item["id"], item["count"])

	cargo.clear()
	status = "idle"
	_update_status_icon()


## Get total item count across all cargo entries.
func _get_cargo_count() -> int:
	var total: int = 0
	for item: Dictionary in cargo:
		total += item["count"]
	return total


## Battery tick — called every second by the timer.
func _on_battery_tick() -> void:
	if status == "shutdown":
		return

	battery_current -= BATTERY_DRAIN_PER_SEC * _battery_timer.wait_time
	battery_current = maxf(battery_current, 0.0)

	if battery_current <= 0.0:
		battery_depleted.emit()
		shutdown()

	_update_status_icon()


## Update the status icon color above the robot.
func _update_status_icon() -> void:
	if _status_icon == null:
		return

	match status:
		"shutdown":
			_status_icon.color = STATUS_COLOR_SHUTDOWN
		"idle":
			_status_icon.color = STATUS_COLOR_IDLE
		"error":
			_status_icon.color = STATUS_COLOR_LOW_BATTERY
		_:
			# Working or moving — check battery level.
			if battery_current < battery_max * 0.2:
				_status_icon.color = STATUS_COLOR_LOW_BATTERY
			else:
				_status_icon.color = STATUS_COLOR_RUNNING
