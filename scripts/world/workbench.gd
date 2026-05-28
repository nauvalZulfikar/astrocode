## Workbench — Interactable crafting station in the world.
## Place in a scene, set tier in the inspector.
## On interact: opens the crafting panel at this workbench's tier.
class_name Workbench
extends StaticBody2D

# --- Exports ---
@export var tier: int = 1

# --- Node refs ---
@onready var sprite: ColorRect = $Sprite
@onready var detect_area: Area2D = $DetectArea
@onready var tier_label: Label = $TierLabel

# Tier display colors.
const TIER_COLORS: Dictionary = {
	1: Color(0.6, 0.6, 0.6),      # Salvage Bench — grey
	2: Color(0.3, 0.5, 0.7),      # Engineering Table — blue
	3: Color(0.6, 0.35, 0.7),     # Fabricator — purple
	4: Color(0.8, 0.6, 0.2),      # Synthesis Lab — gold
}


func _ready() -> void:
	# Set sprite color by tier.
	sprite.color = TIER_COLORS.get(tier, Color.WHITE)

	# Set tier label text.
	var tier_name: String = CraftingManager.TIER_NAMES.get(tier, "Workbench")
	tier_label.text = "T%d" % tier


## Called by the player when pressing interact while nearby.
## Opens the crafting panel at this workbench's tier.
func start_gather(player: Node2D) -> void:
	# Not actually gathering — open crafting UI instead.
	var crafting_panel: Node = _find_crafting_panel()
	if crafting_panel and crafting_panel.has_method("open"):
		crafting_panel.open(tier)


## Find the CraftingPanel in the scene tree.
func _find_crafting_panel() -> Node:
	var tree: SceneTree = get_tree()
	if tree == null:
		return null
	# The crafting panel is a CanvasLayer, search in root.
	return tree.get_first_node_in_group("crafting_panel")


## Get display name for HUD interaction prompt.
func get_interact_prompt() -> String:
	var tier_name: String = CraftingManager.TIER_NAMES.get(tier, "Workbench")
	return "Press E to use %s" % tier_name
