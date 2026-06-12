## ResourceNode — Interactable resource that the player can gather.
## Place in the world, set resource_id and count in the inspector.
class_name ResourceNode
extends StaticBody2D

# --- Exports ---
@export var resource_id: String = "scrap_metal"
@export var resource_count: int = 3
@export var gather_time: float = 1.0  # seconds

# --- Signals ---
signal gathered(rid: String, count: int)

# --- Node refs ---
@onready var sprite: ColorRect = $Sprite
@onready var detect_area: Area2D = $DetectArea

# --- State ---
var _being_gathered: bool = false

# Color mapping for resource types (fallback to InventoryManager DB).
const RESOURCE_COLORS: Dictionary = {
	"scrap_metal": Color(0.6, 0.6, 0.6),
	"copper_wire": Color(0.85, 0.55, 0.2),
	"salt_crystal": Color(0.95, 0.95, 0.85),
	"iron_ore": Color(0.55, 0.3, 0.2),
	"silicon": Color(0.4, 0.45, 0.55),
	"quartz_crystal": Color(0.85, 0.75, 0.95),
	"brine_solution": Color(0.4, 0.7, 0.65),
	"magnetite": Color(0.25, 0.25, 0.3),
	"biomass": Color(0.35, 0.6, 0.25),
}


func _ready() -> void:
	# Set the sprite color based on resource type.
	var col: Color = RESOURCE_COLORS.get(resource_id, Color.WHITE)
	if InventoryManager.ITEM_DB.has(resource_id):
		col = InventoryManager.ITEM_DB[resource_id]["color"]
	sprite.color = col

	# Diamond silhouette: a gem/ore shape that reads as a gatherable resource,
	# distinct from the square stations and robots.
	sprite.pivot_offset = Vector2(4, 4)
	sprite.rotation = deg_to_rad(45)


## Called by the player when pressing interact while nearby.
func start_gather(player: Node2D) -> void:
	if _being_gathered:
		return

	# Energy cost: 1 EP per gather.
	if GameManager.get_stat("energy") < 1.0:
		return  # Not enough energy.

	_being_gathered = true
	GameManager.modify_stat("energy", -1.0 * GameManager.get_energy_drain_multiplier())

	# Tell the player to wait for gather_time.
	if player.has_method("begin_gathering"):
		player.begin_gathering(self, gather_time)


## Called by the player when the gather timer finishes.
func finish_gather(player: Node2D) -> void:
	var success: bool = InventoryManager.add_item(resource_id, resource_count)
	if success:
		gathered.emit(resource_id, resource_count)
	else:
		# Inventory full — resource node stays.
		_being_gathered = false
		return

	# Destroy this resource node.
	queue_free()


## Get display name for HUD interaction prompt.
func get_interact_prompt() -> String:
	var item_name: String = InventoryManager.get_item_name(resource_id)
	return "Press E to gather %s" % item_name
