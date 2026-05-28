## InventoryManager — Manages the player's inventory and item database.
extends Node

# --- Signals ---
signal inventory_changed()
signal item_added(item_id: String, count: int)
signal item_removed(item_id: String, count: int)

# --- Config ---
const MAX_SLOTS: int = 20

# --- Inventory storage ---
## Each entry: {id: String, name: String, count: int, max_stack: int}
var items: Array[Dictionary] = []

# --- Item Database ---
## Master list of all known items. Key = item_id.
const ITEM_DB: Dictionary = {
	# --- Basic / Common resources (Alkaline Flats) ---
	"scrap_metal": {
		"name": "Scrap Metal",
		"max_stack": 50,
		"color": Color(0.6, 0.6, 0.6),       # grey
		"description": "Salvaged metal scraps. The backbone of early construction.",
	},
	"copper_wire": {
		"name": "Copper Wire",
		"max_stack": 99,
		"color": Color(0.85, 0.55, 0.2),      # copper orange
		"description": "Thin copper wiring. Essential for every circuit.",
	},
	"salt_crystal": {
		"name": "Salt Crystal",
		"max_stack": 40,
		"color": Color(0.95, 0.95, 0.85),     # off-white
		"description": "Crystallised mineral salts. Used for insulation and electrolytes.",
	},
	# --- Common resources (Ferric Badlands) ---
	"iron_ore": {
		"name": "Iron Ore",
		"max_stack": 40,
		"color": Color(0.55, 0.3, 0.2),       # rusty brown
		"description": "Dense iron deposits. Smelted into structural material.",
	},
	# --- Uncommon resources ---
	"silicon": {
		"name": "Silicon",
		"max_stack": 30,
		"color": Color(0.4, 0.45, 0.55),      # dark blue-grey
		"description": "Refined silicon. The heart of every chip and solar cell.",
	},
	"quartz_crystal": {
		"name": "Quartz Crystal",
		"max_stack": 20,
		"color": Color(0.85, 0.75, 0.95),     # light purple
		"description": "Precision-cut quartz. Drives oscillators and sensors.",
	},
	"brine_solution": {
		"name": "Brine Solution",
		"max_stack": 20,
		"color": Color(0.4, 0.7, 0.65),       # teal
		"description": "Salty liquid collected from brine pools. Key battery ingredient.",
	},
	"magnetite": {
		"name": "Magnetite",
		"max_stack": 25,
		"color": Color(0.25, 0.25, 0.3),      # dark iron
		"description": "Magnetic mineral. Powers motors and shields.",
	},
	"biomass": {
		"name": "Biomass",
		"max_stack": 40,
		"color": Color(0.35, 0.6, 0.25),      # green
		"description": "Harvested alien fungal matter. Food and fuel source.",
	},
	# --- Crafted intermediates ---
	"circuit_board": {
		"name": "Circuit Board",
		"max_stack": 15,
		"color": Color(0.2, 0.55, 0.2),       # PCB green
		"description": "Assembled circuit board. The brain of every machine.",
	},
	"battery": {
		"name": "Battery",
		"max_stack": 10,
		"color": Color(0.9, 0.85, 0.2),       # yellow
		"description": "Portable power cell. Keeps your robots running.",
	},
	# --- Additional resources from design doc ---
	"enzyme_sap": {
		"name": "Enzyme Sap",
		"max_stack": 15,
		"color": Color(0.7, 0.8, 0.2),
		"description": "Sticky enzyme from fungal trees. Catalyst for refining.",
	},
	"phosphor_spores": {
		"name": "Phosphor Spores",
		"max_stack": 20,
		"color": Color(0.5, 0.9, 0.7),
		"description": "Bioluminescent spores. Only bloom at night.",
	},
	"pure_silica": {
		"name": "Pure Silica",
		"max_stack": 15,
		"color": Color(0.9, 0.9, 0.95),
		"description": "Ultra-refined sand. Advanced chip material.",
	},
	"thaline_crystal": {
		"name": "Thaline Crystal",
		"max_stack": 10,
		"color": Color(0.6, 0.3, 0.9),
		"description": "Rare resonant crystal. Powers the Deep Signal Array.",
	},
	"sensor_module": {
		"name": "Sensor Module",
		"max_stack": 10,
		"color": Color(0.3, 0.6, 0.8),
		"description": "Assembled sensor unit for robots and base systems.",
	},
	"motor": {
		"name": "Motor",
		"max_stack": 8,
		"color": Color(0.5, 0.5, 0.55),
		"description": "Electromagnetic motor. Moves things that need moving.",
	},
	"microcontroller": {
		"name": "Microcontroller",
		"max_stack": 5,
		"color": Color(0.15, 0.4, 0.15),
		"description": "Programmable logic chip. The brain of smart circuits.",
	},
	"bio_fuel": {
		"name": "Bio-Fuel",
		"max_stack": 20,
		"color": Color(0.6, 0.75, 0.1),
		"description": "Refined biological fuel. Trade currency and generator power.",
	},
	# --- Additional crafted intermediates ---
	"cryo_polymer": {
		"name": "Cryo-Polymer",
		"max_stack": 8,
		"color": Color(0.5, 0.8, 0.95),
		"description": "Thermal-hardened polymer. Withstands extreme cold.",
	},
	"superconducting_wire": {
		"name": "Superconducting Wire",
		"max_stack": 5,
		"color": Color(0.7, 0.85, 1.0),
		"description": "Zero-resistance conductor for endgame circuitry.",
	},
	"neural_core": {
		"name": "Neural Core",
		"max_stack": 3,
		"color": Color(0.9, 0.3, 0.6),
		"description": "AI-capable processing unit. The brain of Atlas.",
	},
	"emp_shield": {
		"name": "EMP Shield",
		"max_stack": 5,
		"color": Color(0.35, 0.35, 0.55),
		"description": "Electromagnetic hardening module. Survives resonance storms.",
	},
	# --- Rare / Epic raw resources ---
	"liquid_methane": {
		"name": "Liquid Methane",
		"max_stack": 10,
		"color": Color(0.3, 0.5, 0.7),
		"description": "Cryogenic fuel from polar methane pools.",
	},
	"superconducting_ice": {
		"name": "Superconducting Ice",
		"max_stack": 5,
		"color": Color(0.8, 0.9, 1.0),
		"description": "Exotic ice with zero electrical resistance.",
	},
	"rare_earth_metals": {
		"name": "Rare-Earth Metals",
		"max_stack": 10,
		"color": Color(0.7, 0.55, 0.3),
		"description": "Precious metals for superconductors and advanced circuits.",
	},
	"volcanic_glass": {
		"name": "Volcanic Glass",
		"max_stack": 10,
		"color": Color(0.3, 0.1, 0.1),
		"description": "Heat-forged obsidian. Advanced optics and shielding.",
	},
	"solar_grade_glass": {
		"name": "Solar-Grade Glass",
		"max_stack": 10,
		"color": Color(0.85, 0.9, 1.0),
		"description": "Ultra-clear glass for solar panels and sensor lenses.",
	},
	"piezoelectric_crystal": {
		"name": "Piezoelectric Crystal",
		"max_stack": 8,
		"color": Color(0.6, 0.9, 0.5),
		"description": "Vibration-sensitive crystal for advanced sensors.",
	},
	"ultra_pure_metal": {
		"name": "Ultra-Pure Metal",
		"max_stack": 5,
		"color": Color(0.95, 0.9, 0.8),
		"description": "Magma-refined metal of extreme purity.",
	},
}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


## Add [count] of [item_id] to inventory. Returns false if no room.
func add_item(item_id: String, count: int = 1) -> bool:
	if not ITEM_DB.has(item_id):
		push_warning("InventoryManager: Unknown item '%s'" % item_id)
		return false

	var db_entry: Dictionary = ITEM_DB[item_id]
	var max_stack: int = db_entry["max_stack"]
	var remaining: int = count

	# Try to stack into existing slots first.
	for slot in items:
		if slot["id"] == item_id and slot["count"] < max_stack:
			var space: int = max_stack - slot["count"]
			var to_add: int = mini(remaining, space)
			slot["count"] += to_add
			remaining -= to_add
			if remaining <= 0:
				break

	# Create new slots for leftovers.
	while remaining > 0:
		if items.size() >= MAX_SLOTS:
			# Inventory full — partial add happened; emit what we could.
			var added: int = count - remaining
			if added > 0:
				item_added.emit(item_id, added)
				inventory_changed.emit()
			return false

		var to_add: int = mini(remaining, max_stack)
		items.append({
			"id": item_id,
			"name": db_entry["name"],
			"count": to_add,
			"max_stack": max_stack,
		})
		remaining -= to_add

	item_added.emit(item_id, count)
	inventory_changed.emit()
	return true


## Remove [count] of [item_id]. Returns false if insufficient.
func remove_item(item_id: String, count: int = 1) -> bool:
	if get_count(item_id) < count:
		return false

	var remaining: int = count
	# Iterate in reverse so we can erase empty slots safely.
	for i in range(items.size() - 1, -1, -1):
		if items[i]["id"] == item_id:
			var in_slot: int = items[i]["count"]
			var to_remove: int = mini(remaining, in_slot)
			items[i]["count"] -= to_remove
			remaining -= to_remove
			if items[i]["count"] <= 0:
				items.remove_at(i)
			if remaining <= 0:
				break

	item_removed.emit(item_id, count)
	inventory_changed.emit()
	return true


## Check if we have at least [count] of [item_id].
func has_item(item_id: String, count: int = 1) -> bool:
	return get_count(item_id) >= count


## Total count of [item_id] across all slots.
func get_count(item_id: String) -> int:
	var total: int = 0
	for slot in items:
		if slot["id"] == item_id:
			total += slot["count"]
	return total


## Return a copy of the full inventory array.
func get_all_items() -> Array[Dictionary]:
	return items.duplicate(true)


## Get color for an item (for UI rendering).
func get_item_color(item_id: String) -> Color:
	if ITEM_DB.has(item_id):
		return ITEM_DB[item_id]["color"]
	return Color.WHITE


## Get display name for an item.
func get_item_name(item_id: String) -> String:
	if ITEM_DB.has(item_id):
		return ITEM_DB[item_id]["name"]
	return item_id


## Serialize inventory state for save system.
func serialize() -> Dictionary:
	var serialized_items: Array = []
	for slot: Dictionary in items:
		serialized_items.append({
			"id": slot["id"],
			"count": slot["count"],
		})
	return {"items": serialized_items}


## Deserialize inventory state from save data.
func deserialize(data: Dictionary) -> void:
	items.clear()

	if not data.has("items") or not data["items"] is Array:
		inventory_changed.emit()
		return

	var saved_items: Array = data["items"] as Array
	for entry: Variant in saved_items:
		if not entry is Dictionary:
			continue
		var item_data: Dictionary = entry as Dictionary
		var item_id: String = str(item_data.get("id", ""))
		var count: int = int(item_data.get("count", 0))

		if item_id == "" or count <= 0:
			continue
		if not ITEM_DB.has(item_id):
			push_warning("InventoryManager: Skipping unknown item '%s' from save" % item_id)
			continue

		var db_entry: Dictionary = ITEM_DB[item_id]
		items.append({
			"id": item_id,
			"name": db_entry["name"],
			"count": count,
			"max_stack": db_entry["max_stack"],
		})

	inventory_changed.emit()
