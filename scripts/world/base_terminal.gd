## BaseTerminal — Interactable structure that opens the AstroScript code editor.
## Same interaction pattern as Workbench (StaticBody2D with DetectArea).
class_name BaseTerminal
extends StaticBody2D

# --- Node refs ---
@onready var sprite: ColorRect = $Sprite
@onready var detect_area: Area2D = $DetectArea
@onready var label: Label = $Label

# Terminal color — matches SABLE green theme.
const TERMINAL_COLOR: Color = Color(0.15, 0.35, 0.25)


func _ready() -> void:
	sprite.color = TERMINAL_COLOR
	label.text = "<>"


## Called by the player when pressing interact while nearby.
## Opens the code editor overlay.
func start_gather(_player: Node2D) -> void:
	var editor: Node = _find_code_editor()
	if editor and editor.has_method("open"):
		editor.open()


## Find the CodeEditor in the scene tree.
func _find_code_editor() -> Node:
	var tree: SceneTree = get_tree()
	if tree == null:
		return null
	return tree.get_first_node_in_group("code_editor")


## Get display name for HUD interaction prompt.
func get_interact_prompt() -> String:
	return "Press E to open Code Editor"
