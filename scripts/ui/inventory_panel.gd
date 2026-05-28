## InventoryPanel — Toggle-able inventory grid UI.
## Opens/closes with Tab key. Shows a 4x5 grid of item slots.
extends CanvasLayer

@onready var panel: PanelContainer = $Panel
@onready var grid: GridContainer = $Panel/MarginContainer/VBoxContainer/Grid
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel

const COLUMNS: int = 4
const ROWS: int = 5
const TOTAL_SLOTS: int = COLUMNS * ROWS

var is_open: bool = false

# Slot scene nodes (created at runtime).
var _slot_nodes: Array[PanelContainer] = []


func _ready() -> void:
	# Connect inventory signals.
	InventoryManager.inventory_changed.connect(_refresh_slots)

	# Build the slot grid.
	_build_grid()

	# Start closed.
	panel.visible = false
	is_open = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		toggle()
		get_viewport().set_input_as_handled()


## Toggle the inventory panel open/closed.
func toggle() -> void:
	is_open = !is_open
	panel.visible = is_open
	if is_open:
		_refresh_slots()


## Build the grid of empty slot panels.
func _build_grid() -> void:
	grid.columns = COLUMNS

	for i in range(TOTAL_SLOTS):
		var slot: PanelContainer = PanelContainer.new()
		slot.custom_minimum_size = Vector2(18, 18)

		# Background color for empty slot.
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = Color(0.15, 0.15, 0.2, 0.8)
		style.border_width_left = 1
		style.border_width_right = 1
		style.border_width_top = 1
		style.border_width_bottom = 1
		style.border_color = Color(0.3, 0.3, 0.4)
		style.corner_radius_top_left = 2
		style.corner_radius_top_right = 2
		style.corner_radius_bottom_left = 2
		style.corner_radius_bottom_right = 2
		slot.add_theme_stylebox_override("panel", style)

		# Item color indicator.
		var color_rect: ColorRect = ColorRect.new()
		color_rect.name = "ItemColor"
		color_rect.custom_minimum_size = Vector2(10, 10)
		color_rect.color = Color(0.0, 0.0, 0.0, 0.0)  # Invisible when empty.
		color_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		color_rect.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		slot.add_child(color_rect)

		# Count label.
		var count_label: Label = Label.new()
		count_label.name = "CountLabel"
		count_label.text = ""
		count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		count_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		count_label.add_theme_font_size_override("font_size", 6)
		count_label.add_theme_color_override("font_color", Color.WHITE)
		slot.add_child(count_label)

		grid.add_child(slot)
		_slot_nodes.append(slot)


## Refresh all slots from InventoryManager data.
func _refresh_slots() -> void:
	var items: Array[Dictionary] = InventoryManager.get_all_items()

	for i in range(TOTAL_SLOTS):
		var slot: PanelContainer = _slot_nodes[i]
		var color_rect: ColorRect = slot.get_node("ItemColor")
		var count_label: Label = slot.get_node("CountLabel")

		if i < items.size():
			var item: Dictionary = items[i]
			color_rect.color = InventoryManager.get_item_color(item["id"])
			count_label.text = str(item["count"])
		else:
			color_rect.color = Color(0.0, 0.0, 0.0, 0.0)
			count_label.text = ""
