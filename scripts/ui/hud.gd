## HUD — Heads-up display with stat bars, time, and interaction prompts.
extends CanvasLayer

# --- Node references ---
@onready var health_bar: ProgressBar = $MarginContainer/VBoxLeft/HealthBar
@onready var oxygen_bar: ProgressBar = $MarginContainer/VBoxLeft/OxygenBar
@onready var energy_bar: ProgressBar = $MarginContainer/VBoxLeft/EnergyBar
@onready var hunger_bar: ProgressBar = $MarginContainer/VBoxLeft/HungerBar

@onready var time_label: Label = $MarginContainer/VBoxRight/TimeLabel
@onready var day_night_label: Label = $MarginContainer/VBoxRight/DayNightLabel

@onready var interact_prompt: Label = $InteractPrompt

# Reference to the player (set by main_world or found automatically).
var player: Node2D = null


func _ready() -> void:
	# Connect to GameManager signals.
	GameManager.stat_changed.connect(_on_stat_changed)

	# Connect to TimeManager signals.
	TimeManager.hour_changed.connect(_on_hour_changed)
	TimeManager.day_changed.connect(_on_day_changed)
	TimeManager.night_started.connect(_on_night_started)
	TimeManager.day_started.connect(_on_day_started)

	# Initial UI update.
	_refresh_all_stats()
	_refresh_time()
	interact_prompt.visible = false


func _process(_delta: float) -> void:
	_update_interact_prompt()
	# Update time display every frame for smooth minute counter.
	time_label.text = TimeManager.get_time_string()


## Refresh all stat bars from GameManager.
func _refresh_all_stats() -> void:
	health_bar.value = GameManager.get_stat("health")
	oxygen_bar.value = GameManager.get_stat("oxygen")
	energy_bar.value = GameManager.get_stat("energy")
	hunger_bar.value = GameManager.get_stat("hunger")


func _refresh_time() -> void:
	time_label.text = TimeManager.get_time_string()
	day_night_label.text = "NIGHT" if TimeManager.is_night else "DAY"


## Show or hide the interaction prompt based on player proximity.
func _update_interact_prompt() -> void:
	if player == null:
		# Try to find the player.
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			interact_prompt.visible = false
			return

	if player.has_method("get_nearest_interactable"):
		var target: Node2D = player.get_nearest_interactable()
		if target and is_instance_valid(target):
			if target.has_method("get_interact_prompt"):
				interact_prompt.text = target.get_interact_prompt()
			else:
				interact_prompt.text = "Press E to interact"
			interact_prompt.visible = true

			# Hide prompt while gathering.
			if player.has_method("is_gathering") and player.is_gathering():
				interact_prompt.text = "Gathering..."
		else:
			interact_prompt.visible = false
	else:
		interact_prompt.visible = false


# --- Signal callbacks ---
func _on_stat_changed(stat_name: String, new_value: float) -> void:
	match stat_name:
		"health":
			health_bar.value = new_value
		"oxygen":
			oxygen_bar.value = new_value
		"energy":
			energy_bar.value = new_value
		"hunger":
			hunger_bar.value = new_value


func _on_hour_changed(_hour: int) -> void:
	_refresh_time()


func _on_day_changed(_day: int) -> void:
	_refresh_time()


func _on_night_started() -> void:
	day_night_label.text = "NIGHT"


func _on_day_started() -> void:
	day_night_label.text = "DAY"
