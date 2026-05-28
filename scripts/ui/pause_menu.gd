## PauseMenu — Escape-key pause overlay.
## Buttons: Resume, Save Game, Load Game, Settings (placeholder), Quit.
## Pauses the game tree while open.
extends CanvasLayer

# --- Signals ---
signal save_requested()
signal load_requested()

# --- Node references ---
@onready var panel: PanelContainer = $Panel
@onready var btn_resume: Button = $Panel/MarginContainer/VBox/BtnResume
@onready var btn_save: Button = $Panel/MarginContainer/VBox/BtnSave
@onready var btn_load: Button = $Panel/MarginContainer/VBox/BtnLoad
@onready var btn_settings: Button = $Panel/MarginContainer/VBox/BtnSettings
@onready var btn_quit: Button = $Panel/MarginContainer/VBox/BtnQuit

var is_open: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.visible = false
	is_open = false

	btn_resume.pressed.connect(_on_resume_pressed)
	btn_save.pressed.connect(_on_save_pressed)
	btn_load.pressed.connect(_on_load_pressed)
	btn_settings.pressed.connect(_on_settings_pressed)
	btn_quit.pressed.connect(_on_quit_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_open:
			close()
		else:
			open()
		get_viewport().set_input_as_handled()


## Open the pause menu and freeze the game.
func open() -> void:
	is_open = true
	panel.visible = true
	get_tree().paused = true


## Close the pause menu and resume the game.
func close() -> void:
	is_open = false
	panel.visible = false
	get_tree().paused = false


func _on_resume_pressed() -> void:
	close()


func _on_save_pressed() -> void:
	save_requested.emit()


func _on_load_pressed() -> void:
	load_requested.emit()


func _on_settings_pressed() -> void:
	# Placeholder — settings panel not yet implemented.
	pass


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
