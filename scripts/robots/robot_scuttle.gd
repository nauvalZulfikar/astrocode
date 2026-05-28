## RobotScuttle — Gatherer-class robot.
## Overrides: faster gather speed, auto-harvest tagged resource nodes.
class_name RobotScuttle
extends RobotBase

# --- Config ---
## Gather time multiplier (faster than base).
const GATHER_TIME_MULT: float = 0.6
## Auto-harvest scan radius in pixels.
const AUTO_HARVEST_RADIUS: float = 64.0
## Interval between auto-harvest scans (seconds).
const AUTO_HARVEST_INTERVAL: float = 5.0

# --- Internal ---
var _auto_harvest_timer: float = 0.0
## Resource IDs that are "tagged" for auto-harvest.
var tagged_resources: PackedStringArray = PackedStringArray()


func _ready() -> void:
	super._ready()
	robot_type = "scuttle"


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if status == "shutdown":
		return

	# Auto-harvest scan.
	_auto_harvest_timer -= delta
	if _auto_harvest_timer <= 0.0:
		_auto_harvest_timer = AUTO_HARVEST_INTERVAL
		_scan_for_tagged_resources()


## Override gather time — Scuttle gathers faster.
func _get_gather_time() -> float:
	return 1.5 * GATHER_TIME_MULT


## Tag a resource type for auto-harvesting.
func tag_resource(resource_id: String) -> void:
	if resource_id not in tagged_resources:
		tagged_resources.append(resource_id)


## Remove a resource tag.
func untag_resource(resource_id: String) -> void:
	var idx: int = tagged_resources.find(resource_id)
	if idx >= 0:
		tagged_resources.remove_at(idx)


## Scan nearby resource nodes and auto-queue gather tasks for tagged types.
func _scan_for_tagged_resources() -> void:
	if status != "idle":
		return
	if tagged_resources.is_empty():
		return
	if _get_cargo_count() >= max_cargo:
		return

	var nodes: Array[Node] = get_tree().get_nodes_in_group("resources")
	var closest: Node2D = null
	var closest_dist: float = INF

	for node: Node in nodes:
		var rnode: Node2D = node as Node2D
		if rnode and is_instance_valid(rnode):
			if rnode.resource_id in tagged_resources:
				var dist: float = global_position.distance_to(rnode.global_position)
				if dist < AUTO_HARVEST_RADIUS and dist < closest_dist:
					closest_dist = dist
					closest = rnode

	if closest:
		# Queue move + gather.
		assign_task({
			"type": "move_to",
			"target_x": closest.global_position.x,
			"target_y": closest.global_position.y,
		})
		assign_task({
			"type": "gather",
			"resource_id": closest.resource_id,
		})
