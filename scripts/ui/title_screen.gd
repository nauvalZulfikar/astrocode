## TitleScreen — main menu. Displays a swappable background image so the Higgsfield
## title art drops straight in: put the file at res://assets/ui/title_bg.png and it
## shows automatically; otherwise a procedural Alkaline-Flats backdrop is used.
extends Control

const BG_PATH: String = "res://assets/ui/title_bg.png"
const WORLD_SCENE: String = "res://scenes/world/main_world.tscn"

@onready var bg_texture: TextureRect = $BgTexture
@onready var bg_fallback: ColorRect = $BgFallback
@onready var new_game_btn: Button = $CenterContainer/VBox/NewGameBtn
@onready var quit_btn: Button = $CenterContainer/VBox/QuitBtn


func _ready() -> void:
	_load_background()
	new_game_btn.pressed.connect(_on_new_game)
	quit_btn.pressed.connect(_on_quit)
	new_game_btn.grab_focus()


## Use the dropped-in title art if present, else the procedural fallback.
func _load_background() -> void:
	if ResourceLoader.exists(BG_PATH):
		bg_texture.texture = load(BG_PATH)
		bg_texture.visible = true
		bg_fallback.visible = false
	else:
		bg_texture.visible = false
		bg_fallback.visible = true


func _on_new_game() -> void:
	get_tree().change_scene_to_file(WORLD_SCENE)


func _on_quit() -> void:
	get_tree().quit()
