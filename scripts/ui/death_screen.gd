## DeathScreen — Shown when the player dies (HP or O2 reaches 0).
## Displays cause of death, educational SABLE message, and a respawn button.
## No permadeath — player respawns at base with penalties.
extends CanvasLayer

# --- Node references ---
@onready var panel: PanelContainer = $Panel
@onready var cause_label: Label = $Panel/MarginContainer/VBox/CauseLabel
@onready var sable_label: Label = $Panel/MarginContainer/VBox/SableLabel
@onready var btn_respawn: Button = $Panel/MarginContainer/VBox/BtnRespawn

var is_open: bool = false

# Base respawn position (origin — the starting base).
const RESPAWN_POS: Vector2 = Vector2(0.0, 0.0)

# SABLE educational messages per death cause.
const SABLE_MESSAGES: Dictionary = {
	"oxygen": "SABLE: Your O2 recycler had no error handling for sensor disconnection. Always validate sensor input before trusting readings — a null check could have saved you.",
	"health": "SABLE: Your health reached zero. Monitor your stat thresholds in code — set up an alert callback when HP drops below 20 so you can react before it is too late.",
}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.visible = false
	is_open = false

	btn_respawn.pressed.connect(_on_respawn_pressed)

	# Connect to player death signal.
	GameManager.player_died.connect(_on_player_died)


## Show the death screen with the given cause.
func show_death(cause: String) -> void:
	is_open = true
	panel.visible = true
	get_tree().paused = true

	# Set cause text.
	match cause:
		"oxygen":
			cause_label.text = "You ran out of oxygen."
		"health":
			cause_label.text = "Health reached zero."
		_:
			cause_label.text = "You died."

	# Set SABLE educational message.
	sable_label.text = SABLE_MESSAGES.get(cause, "SABLE: Analyze what went wrong and build a system to prevent it next time.")


## Handle respawn — reset player to base with penalties.
func _on_respawn_pressed() -> void:
	# Find the player.
	var player: Node2D = get_tree().get_first_node_in_group("player")
	if player == null:
		var scene: Node = get_tree().current_scene
		if scene and scene.has_node("Player"):
			player = scene.get_node("Player") as Node2D

	# Reset player position to base.
	if player and is_instance_valid(player):
		player.global_position = RESPAWN_POS

	# Reset stats: 50% HP, 50 O2. Energy/hunger unchanged.
	GameManager.modify_stat("health", 50.0 - GameManager.get_stat("health"))
	GameManager.modify_stat("oxygen", 50.0 - GameManager.get_stat("oxygen"))

	# Clear personal inventory (NOT base storage — base storage is a separate system).
	InventoryManager.items.clear()
	InventoryManager.inventory_changed.emit()

	# Close death screen and resume.
	is_open = false
	panel.visible = false
	get_tree().paused = false


## Signal handler for player death.
func _on_player_died(cause: String) -> void:
	show_death(cause)
