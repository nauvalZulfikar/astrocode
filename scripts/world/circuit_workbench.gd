## CircuitWorkbench — Interactable world object that opens the Circuit Builder.
## Same interaction pattern as Workbench / BaseTerminal (StaticBody2D + DetectArea).
class_name CircuitWorkbench
extends StaticBody2D

# --- Exports ---
## Optional puzzle context. Leave empty for free-build mode.
@export var puzzle_id: String = ""

# --- Node refs ---
@onready var sprite: ColorRect = $Sprite
@onready var detect_area: Area2D = $DetectArea
@onready var label: Label = $Label

# Workbench color — electronics yellow-green tint.
const WORKBENCH_COLOR: Color = Color(0.55, 0.6, 0.3)


func _ready() -> void:
	sprite.color = WORKBENCH_COLOR
	if puzzle_id != "":
		label.text = "CB"
	else:
		label.text = "CB"


## Called by the player when pressing interact while nearby.
## Opens the circuit builder overlay.
func start_gather(_player: Node2D) -> void:
	var builder: Node = _find_circuit_builder()
	if builder and builder.has_method("open"):
		builder.open(puzzle_id)


## Find the CircuitBuilder in the scene tree.
func _find_circuit_builder() -> Node:
	var tree: SceneTree = get_tree()
	if tree == null:
		return null
	return tree.get_first_node_in_group("circuit_builder")


## Get display name for HUD interaction prompt.
func get_interact_prompt() -> String:
	if puzzle_id != "":
		return "Press E to open Circuit Puzzle"
	return "Press E to open Circuit Builder"
