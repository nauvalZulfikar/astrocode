## Player — Top-down CharacterBody2D with 8-directional movement.
## Handles movement, sprinting, and interaction with nearby objects.
class_name Player
extends CharacterBody2D

# --- Export ---
@export var walk_speed: float = 80.0
@export var sprint_speed: float = 120.0

# --- Signals ---
signal interacted_with(body: Node2D)

# --- Node references ---
@onready var interaction_area: Area2D = $InteractionArea
@onready var sprite: Sprite2D = $Sprite

# --- Directional sprites (Kade, 8-way static rotation) ---
const DIR_TEXTURES: Dictionary = {
	"east": preload("res://assets/sprites/player/kade/east.png"),
	"south-east": preload("res://assets/sprites/player/kade/south-east.png"),
	"south": preload("res://assets/sprites/player/kade/south.png"),
	"south-west": preload("res://assets/sprites/player/kade/south-west.png"),
	"west": preload("res://assets/sprites/player/kade/west.png"),
	"north-west": preload("res://assets/sprites/player/kade/north-west.png"),
	"north": preload("res://assets/sprites/player/kade/north.png"),
	"north-east": preload("res://assets/sprites/player/kade/north-east.png"),
}
# Index order matches round(angle / 45deg), angle from Vector2.angle() (y-down, 0 = east).
const DIR_ORDER: Array[String] = [
	"east", "south-east", "south", "south-west",
	"west", "north-west", "north", "north-east",
]
var _facing: String = "south"

# --- Internal ---
var _nearby_interactables: Array[Node2D] = []
var _is_gathering: bool = false
var _gather_timer: float = 0.0
var _gather_target: Node2D = null


func _ready() -> void:
	interaction_area.body_entered.connect(_on_interaction_body_entered)
	interaction_area.body_exited.connect(_on_interaction_body_exited)
	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)

	GameManager.player_died.connect(_on_player_died)

	# Start facing south (idle).
	sprite.texture = DIR_TEXTURES[_facing]


func _physics_process(delta: float) -> void:
	# Block movement during active dialogue.
	if DialogueManager.is_dialogue_active():
		velocity = Vector2.ZERO
		return

	if _is_gathering:
		_process_gathering(delta)
		return

	# --- Movement ---
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var is_sprinting: bool = Input.is_action_pressed("sprint") and input_dir.length() > 0.0

	# Check if we can sprint (need energy).
	if is_sprinting and GameManager.get_stat("energy") <= 0.0:
		is_sprinting = false

	var speed: float = sprint_speed if is_sprinting else walk_speed

	# Critical HP penalty: -30% movement.
	if GameManager.get_stat("health") <= 20.0:
		speed *= 0.7

	# Low energy: cannot sprint.
	if GameManager.get_stat("energy") <= 10.0:
		speed = minf(speed, walk_speed)

	velocity = input_dir.normalized() * speed
	move_and_slide()

	# Update facing sprite when moving.
	if input_dir.length() > 0.0:
		_update_facing(input_dir)

	# Sprint energy cost: -1 EP per 15 real seconds.
	if is_sprinting:
		var drain: float = (1.0 / 15.0) * delta * GameManager.get_energy_drain_multiplier()
		GameManager.modify_stat("energy", -drain)

	# --- Interaction input ---
	if Input.is_action_just_pressed("interact"):
		_try_interact()


## Snap a movement vector to the nearest of 8 directions and swap the sprite.
func _update_facing(dir: Vector2) -> void:
	var idx: int = int(round(dir.angle() / (PI / 4.0)))
	idx = ((idx % 8) + 8) % 8
	var dir_name: String = DIR_ORDER[idx]
	if dir_name != _facing:
		_facing = dir_name
		sprite.texture = DIR_TEXTURES[dir_name]


## Attempt to interact with the nearest interactable.
func _try_interact() -> void:
	if _nearby_interactables.is_empty():
		return

	# Find the closest interactable.
	var closest: Node2D = null
	var closest_dist: float = INF
	for obj in _nearby_interactables:
		if not is_instance_valid(obj):
			continue
		var dist: float = global_position.distance_to(obj.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = obj

	if closest == null:
		return

	# If it's a resource node, start gathering.
	if closest.has_method("start_gather"):
		closest.start_gather(self)
	else:
		interacted_with.emit(closest)


## Begin a timed gather action.
func begin_gathering(target: Node2D, duration: float) -> void:
	_is_gathering = true
	_gather_timer = duration
	_gather_target = target


func _process_gathering(delta: float) -> void:
	_gather_timer -= delta
	if _gather_timer <= 0.0:
		_is_gathering = false
		if is_instance_valid(_gather_target) and _gather_target.has_method("finish_gather"):
			_gather_target.finish_gather(self)
		_gather_target = null


## Get the nearest interactable (used by HUD for prompt text).
func get_nearest_interactable() -> Node2D:
	var closest: Node2D = null
	var closest_dist: float = INF
	for obj in _nearby_interactables:
		if not is_instance_valid(obj):
			continue
		var dist: float = global_position.distance_to(obj.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = obj
	return closest


## Returns true if currently in a gather animation.
func is_gathering() -> bool:
	return _is_gathering


# --- Interaction area callbacks ---
func _on_interaction_body_entered(body: Node2D) -> void:
	if body != self and body not in _nearby_interactables:
		_nearby_interactables.append(body)


func _on_interaction_body_exited(body: Node2D) -> void:
	_nearby_interactables.erase(body)


func _on_interaction_area_entered(area: Area2D) -> void:
	var parent: Node2D = area.get_parent() as Node2D
	if parent and parent != self and parent not in _nearby_interactables:
		_nearby_interactables.append(parent)


func _on_interaction_area_exited(area: Area2D) -> void:
	var parent: Node2D = area.get_parent() as Node2D
	if parent:
		_nearby_interactables.erase(parent)


func _on_player_died(_cause: String) -> void:
	# Death/respawn is now handled by DeathScreen UI.
	# Stop player movement immediately on death.
	velocity = Vector2.ZERO
	_is_gathering = false
	_gather_target = null
