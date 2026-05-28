## CraftingPanel — UI panel for crafting items at workbenches.
## Opens when interacting with a workbench or pressing C (hand-crafting).
## Shows available recipes filtered by workbench tier, ingredient status,
## and a craft button with a timer.
extends CanvasLayer

# --- Node references ---
@onready var panel: PanelContainer = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var recipe_list: VBoxContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/RecipeList
@onready var scroll_container: ScrollContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer

# --- State ---
var is_open: bool = false
var _active_tier: int = 0
var _is_crafting: bool = false
var _craft_timer: float = 0.0
var _craft_recipe_id: String = ""
var _craft_button_ref: Button = null
var _craft_progress_ref: ProgressBar = null
var _craft_total_time: float = 0.0


func _ready() -> void:
	# Add to group so workbenches can find this panel.
	add_to_group("crafting_panel")

	# Connect signals.
	InventoryManager.inventory_changed.connect(_on_inventory_changed)
	CraftingManager.item_crafted.connect(_on_item_crafted)

	# Start closed.
	panel.visible = false
	is_open = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_crafting"):
		if is_open:
			close()
		else:
			open(0)  # Hand-crafting tier.
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if not _is_crafting:
		return

	_craft_timer -= delta
	if _craft_progress_ref and is_instance_valid(_craft_progress_ref):
		var elapsed: float = _craft_total_time - _craft_timer
		_craft_progress_ref.value = elapsed

	if _craft_timer <= 0.0:
		_finish_craft()


## Open the crafting panel at the given workbench tier.
func open(tier: int) -> void:
	_active_tier = tier
	CraftingManager.current_tier = tier
	is_open = true
	panel.visible = true
	title_label.text = CraftingManager.TIER_NAMES.get(tier, "Crafting")
	_rebuild_recipe_list()


## Close the crafting panel.
func close() -> void:
	is_open = false
	panel.visible = false
	_cancel_craft()


## Rebuild the recipe list from CraftingManager data.
func _rebuild_recipe_list() -> void:
	# Clear existing entries.
	for child in recipe_list.get_children():
		child.queue_free()

	var recipes: Array = CraftingManager.get_available_recipes(_active_tier)

	if recipes.is_empty():
		var empty_label: Label = Label.new()
		empty_label.text = "No recipes available"
		empty_label.add_theme_font_size_override("font_size", 6)
		empty_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		recipe_list.add_child(empty_label)
		return

	for recipe: Dictionary in recipes:
		var row: PanelContainer = _create_recipe_row(recipe)
		recipe_list.add_child(row)


## Create a single recipe row UI element.
func _create_recipe_row(recipe: Dictionary) -> PanelContainer:
	var row: PanelContainer = PanelContainer.new()
	row.custom_minimum_size = Vector2(0, 26)
	row.name = "Recipe_%s" % recipe["id"]

	# Row background style.
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.12, 0.18, 0.9)
	style.border_width_bottom = 1
	style.border_color = Color(0.25, 0.25, 0.35)
	style.corner_radius_top_left = 1
	style.corner_radius_top_right = 1
	style.corner_radius_bottom_left = 1
	style.corner_radius_bottom_right = 1
	style.content_margin_left = 3
	style.content_margin_right = 3
	style.content_margin_top = 2
	style.content_margin_bottom = 2
	row.add_theme_stylebox_override("panel", style)

	var hbox: HBoxContainer = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 4)
	row.add_child(hbox)

	# --- Left section: name + result count ---
	var name_vbox: VBoxContainer = VBoxContainer.new()
	name_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var name_label: Label = Label.new()
	var result_text: String = recipe["name"]
	if recipe["result_count"] > 1:
		result_text += " x%d" % recipe["result_count"]
	name_label.text = result_text
	name_label.add_theme_font_size_override("font_size", 6)
	name_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.85))
	name_vbox.add_child(name_label)

	# --- Ingredient list ---
	var ingredients_label: Label = Label.new()
	var ingredients_text: String = _format_ingredients(recipe)
	ingredients_label.text = ingredients_text
	ingredients_label.add_theme_font_size_override("font_size", 5)
	ingredients_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.65))
	name_vbox.add_child(ingredients_label)

	hbox.add_child(name_vbox)

	# --- Right section: craft button + progress ---
	var right_vbox: VBoxContainer = VBoxContainer.new()
	right_vbox.custom_minimum_size = Vector2(28, 0)

	var can_craft: bool = CraftingManager.can_craft(recipe["id"])

	var craft_button: Button = Button.new()
	craft_button.name = "CraftBtn"
	craft_button.text = "Craft"
	craft_button.custom_minimum_size = Vector2(26, 10)
	craft_button.add_theme_font_size_override("font_size", 5)
	craft_button.disabled = not can_craft
	craft_button.pressed.connect(_on_craft_pressed.bind(recipe["id"], craft_button, row))
	right_vbox.add_child(craft_button)

	# Progress bar (hidden until crafting).
	var progress: ProgressBar = ProgressBar.new()
	progress.name = "CraftProgress"
	progress.custom_minimum_size = Vector2(26, 3)
	progress.max_value = recipe["craft_time"]
	progress.value = 0.0
	progress.show_percentage = false
	progress.visible = false

	var progress_fill: StyleBoxFlat = StyleBoxFlat.new()
	progress_fill.bg_color = Color(0.3, 0.8, 0.3, 1)
	progress_fill.corner_radius_top_left = 1
	progress_fill.corner_radius_top_right = 1
	progress_fill.corner_radius_bottom_right = 1
	progress_fill.corner_radius_bottom_left = 1
	progress.add_theme_stylebox_override("fill", progress_fill)

	var progress_bg: StyleBoxFlat = StyleBoxFlat.new()
	progress_bg.bg_color = Color(0.1, 0.1, 0.15, 0.8)
	progress_bg.corner_radius_top_left = 1
	progress_bg.corner_radius_top_right = 1
	progress_bg.corner_radius_bottom_right = 1
	progress_bg.corner_radius_bottom_left = 1
	progress.add_theme_stylebox_override("background", progress_bg)

	right_vbox.add_child(progress)

	hbox.add_child(right_vbox)

	return row


## Format ingredient text with have/need counts.
func _format_ingredients(recipe: Dictionary) -> String:
	var parts: PackedStringArray = PackedStringArray()
	var ingredients: Dictionary = recipe["ingredients"]
	for item_id: String in ingredients:
		var needed: int = ingredients[item_id]
		var have: int = InventoryManager.get_count(item_id)
		var item_name: String = InventoryManager.get_item_name(item_id)
		parts.append("%s %d/%d" % [item_name, have, needed])
	return ", ".join(parts)


## Handle craft button press — start the craft timer.
func _on_craft_pressed(recipe_id: String, button: Button, _row: PanelContainer) -> void:
	if _is_crafting:
		return

	if not CraftingManager.can_craft(recipe_id):
		return

	var recipe: Dictionary = CraftingManager.get_recipe(recipe_id)
	if recipe.is_empty():
		return

	_is_crafting = true
	_craft_recipe_id = recipe_id
	_craft_timer = recipe["craft_time"]
	_craft_total_time = recipe["craft_time"]
	_craft_button_ref = button

	# Find and show the progress bar.
	var right_vbox: VBoxContainer = button.get_parent() as VBoxContainer
	if right_vbox:
		var progress: ProgressBar = right_vbox.get_node_or_null("CraftProgress")
		if progress:
			progress.max_value = _craft_total_time
			progress.value = 0.0
			progress.visible = true
			_craft_progress_ref = progress

	button.disabled = true
	button.text = "..."

	# Disable all other craft buttons while crafting.
	_set_all_buttons_disabled(true)


## Finish crafting: consume ingredients, add result.
func _finish_craft() -> void:
	var success: bool = CraftingManager.craft(_craft_recipe_id)
	if not success:
		push_warning("CraftingPanel: Craft failed for '%s'" % _craft_recipe_id)

	_is_crafting = false
	_craft_recipe_id = ""
	_craft_timer = 0.0
	_craft_button_ref = null

	if _craft_progress_ref and is_instance_valid(_craft_progress_ref):
		_craft_progress_ref.visible = false
		_craft_progress_ref = null

	# Rebuild the list to refresh have/need counts and button states.
	_rebuild_recipe_list()


## Cancel an in-progress craft (e.g., panel closed).
func _cancel_craft() -> void:
	_is_crafting = false
	_craft_recipe_id = ""
	_craft_timer = 0.0
	_craft_button_ref = null
	_craft_progress_ref = null


## Disable/enable all craft buttons in the list.
func _set_all_buttons_disabled(disabled: bool) -> void:
	for child in recipe_list.get_children():
		if child is PanelContainer:
			var btn: Button = _find_craft_button(child)
			if btn:
				btn.disabled = disabled


## Recursively find the CraftBtn in a recipe row.
func _find_craft_button(node: Node) -> Button:
	if node is Button and node.name == "CraftBtn":
		return node as Button
	for child in node.get_children():
		var found: Button = _find_craft_button(child)
		if found:
			return found
	return null


## Refresh button states when inventory changes.
func _on_inventory_changed() -> void:
	if not is_open:
		return
	# Only refresh if not actively crafting (avoid disrupting progress bar).
	if _is_crafting:
		return
	_rebuild_recipe_list()


## Called when an item is crafted (from CraftingManager signal).
func _on_item_crafted(_recipe_id: String) -> void:
	pass  # Could play a sound or particle effect here.
