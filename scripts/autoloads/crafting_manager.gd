## CraftingManager — Recipe database and crafting logic.
## Manages all crafting recipes, workbench tiers, and item production.
extends Node

# --- Signals ---
signal item_crafted(recipe_id: String)

# --- State ---
## Current workbench tier (0=hand, 1=salvage, 2=engineering, 3=fabricator, 4=synthesis).
var current_tier: int = 0

# --- Workbench tier names ---
const TIER_NAMES: Dictionary = {
	0: "Hand Crafting",
	1: "Salvage Bench",
	2: "Engineering Table",
	3: "Fabricator",
	4: "Synthesis Lab",
}

# --- Recipe Database ---
## Each recipe: {id, name, ingredients, result_id, result_count, workbench_tier, craft_time}
## ingredients is a Dictionary of {item_id: count_needed}.
const RECIPES: Dictionary = {
	"circuit_board": {
		"id": "circuit_board",
		"name": "Circuit Board",
		"ingredients": {
			"copper_wire": 3,
			"silicon": 2,
			"salt_crystal": 1,
		},
		"result_id": "circuit_board",
		"result_count": 1,
		"workbench_tier": 1,
		"craft_time": 3.0,
	},
	"battery": {
		"id": "battery",
		"name": "Battery",
		"ingredients": {
			"brine_solution": 2,
			"copper_wire": 1,
			"salt_crystal": 1,
		},
		"result_id": "battery",
		"result_count": 1,
		"workbench_tier": 1,
		"craft_time": 3.0,
	},
	"sensor_module": {
		"id": "sensor_module",
		"name": "Sensor Module",
		"ingredients": {
			"circuit_board": 1,
			"quartz_crystal": 1,
			"copper_wire": 2,
		},
		"result_id": "sensor_module",
		"result_count": 1,
		"workbench_tier": 2,
		"craft_time": 4.0,
	},
	"motor": {
		"id": "motor",
		"name": "Motor",
		"ingredients": {
			"iron_ore": 2,
			"magnetite": 1,
			"copper_wire": 1,
		},
		"result_id": "motor",
		"result_count": 1,
		"workbench_tier": 2,
		"craft_time": 4.0,
	},
	"microcontroller": {
		"id": "microcontroller",
		"name": "Microcontroller",
		"ingredients": {
			"circuit_board": 2,
			"pure_silica": 1,
			"quartz_crystal": 1,
		},
		"result_id": "microcontroller",
		"result_count": 1,
		"workbench_tier": 3,
		"craft_time": 6.0,
	},
	"bio_fuel": {
		"id": "bio_fuel",
		"name": "Bio-Fuel",
		"ingredients": {
			"biomass": 4,
			"enzyme_sap": 1,
		},
		"result_id": "bio_fuel",
		"result_count": 5,
		"workbench_tier": 1,
		"craft_time": 2.0,
	},
	"cryo_polymer": {
		"id": "cryo_polymer",
		"name": "Cryo-Polymer",
		"ingredients": {
			"liquid_methane": 2,
			"enzyme_sap": 1,
			"salt_crystal": 1,
		},
		"result_id": "cryo_polymer",
		"result_count": 1,
		"workbench_tier": 3,
		"craft_time": 5.0,
	},
	"superconducting_wire": {
		"id": "superconducting_wire",
		"name": "Superconducting Wire",
		"ingredients": {
			"superconducting_ice": 2,
			"copper_wire": 1,
			"rare_earth_metals": 1,
		},
		"result_id": "superconducting_wire",
		"result_count": 1,
		"workbench_tier": 4,
		"craft_time": 8.0,
	},
	"neural_core": {
		"id": "neural_core",
		"name": "Neural Core",
		"ingredients": {
			"microcontroller": 1,
			"thaline_crystal": 2,
			"pure_silica": 1,
		},
		"result_id": "neural_core",
		"result_count": 1,
		"workbench_tier": 4,
		"craft_time": 10.0,
	},
	"emp_shield": {
		"id": "emp_shield",
		"name": "EMP Shield",
		"ingredients": {
			"magnetite": 2,
			"iron_ore": 1,
			"circuit_board": 1,
		},
		"result_id": "emp_shield",
		"result_count": 1,
		"workbench_tier": 2,
		"craft_time": 4.0,
	},
}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


## Check if the player has enough ingredients AND the correct workbench tier.
func can_craft(recipe_id: String) -> bool:
	if not RECIPES.has(recipe_id):
		push_warning("CraftingManager: Unknown recipe '%s'" % recipe_id)
		return false

	var recipe: Dictionary = RECIPES[recipe_id]

	# Check workbench tier.
	if current_tier < recipe["workbench_tier"]:
		return false

	# Check all ingredients.
	var ingredients: Dictionary = recipe["ingredients"]
	for item_id: String in ingredients:
		var needed: int = ingredients[item_id]
		if not InventoryManager.has_item(item_id, needed):
			return false

	return true


## Consume ingredients and add the result to inventory. Returns false on failure.
func craft(recipe_id: String) -> bool:
	if not can_craft(recipe_id):
		return false

	var recipe: Dictionary = RECIPES[recipe_id]

	# Consume all ingredients.
	var ingredients: Dictionary = recipe["ingredients"]
	for item_id: String in ingredients:
		var needed: int = ingredients[item_id]
		var success: bool = InventoryManager.remove_item(item_id, needed)
		if not success:
			# This should not happen since can_craft passed, but guard anyway.
			push_error("CraftingManager: Failed to remove '%s' during craft" % item_id)
			return false

	# Add result to inventory.
	var added: bool = InventoryManager.add_item(recipe["result_id"], recipe["result_count"])
	if not added:
		# Inventory full — refund ingredients.
		for item_id: String in ingredients:
			var needed: int = ingredients[item_id]
			InventoryManager.add_item(item_id, needed)
		return false

	item_crafted.emit(recipe_id)
	return true


## Get all recipes available at the given workbench tier (includes lower tiers).
func get_available_recipes(workbench_tier: int) -> Array:
	var result: Array = []
	for recipe_id: String in RECIPES:
		var recipe: Dictionary = RECIPES[recipe_id]
		if recipe["workbench_tier"] <= workbench_tier:
			result.append(recipe)
	return result


## Get a single recipe by ID. Returns empty Dictionary if not found.
func get_recipe(recipe_id: String) -> Dictionary:
	if RECIPES.has(recipe_id):
		return RECIPES[recipe_id]
	return {}


## Serialize crafting state for save system.
func serialize() -> Dictionary:
	return {
		"current_tier": current_tier,
	}


## Deserialize crafting state from save data.
func deserialize(data: Dictionary) -> void:
	current_tier = int(data.get("current_tier", 0))
