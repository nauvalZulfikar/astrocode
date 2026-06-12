## QuestJournal — Toggle-able quest log panel.
## Opens/closes with J key. Shows active and completed quests.
extends CanvasLayer

# --- Node references ---
@onready var panel: PanelContainer = $Panel
@onready var active_container: VBoxContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/QuestList/ActiveSection/ActiveList
@onready var completed_container: VBoxContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/QuestList/CompletedSection/CompletedList

var is_open: bool = false


func _ready() -> void:
	# Connect quest signals.
	DialogueManager.quest_accepted.connect(_on_quest_changed)
	DialogueManager.quest_completed.connect(_on_quest_changed)

	# Start closed.
	panel.visible = false
	is_open = false


func _unhandled_input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("pause"):
		toggle()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("open_journal"):
		toggle()
		get_viewport().set_input_as_handled()


## Toggle the journal panel open/closed.
func toggle() -> void:
	is_open = !is_open
	panel.visible = is_open
	if is_open:
		_refresh()


## Refresh the quest lists from DialogueManager.
func _refresh() -> void:
	# Clear existing entries.
	for child: Node in active_container.get_children():
		child.queue_free()
	for child: Node in completed_container.get_children():
		child.queue_free()

	# Active quests.
	var active: Array[Dictionary] = DialogueManager.get_active_quest_entries()
	if active.is_empty():
		var empty_label: Label = Label.new()
		empty_label.text = "No active quests."
		empty_label.add_theme_font_size_override("font_size", 6)
		empty_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		active_container.add_child(empty_label)
	else:
		for entry: Dictionary in active:
			_add_quest_entry(active_container, entry)

	# Completed quests.
	var completed: Array[Dictionary] = DialogueManager.get_completed_quest_entries()
	if completed.is_empty():
		var empty_label: Label = Label.new()
		empty_label.text = "No completed quests."
		empty_label.add_theme_font_size_override("font_size", 6)
		empty_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		completed_container.add_child(empty_label)
	else:
		for entry: Dictionary in completed:
			_add_quest_entry(completed_container, entry)


## Add a quest entry to the given container.
func _add_quest_entry(container: VBoxContainer, entry: Dictionary) -> void:
	var quest_panel: PanelContainer = PanelContainer.new()
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.12, 0.18, 0.9)
	style.corner_radius_top_left = 2
	style.corner_radius_top_right = 2
	style.corner_radius_bottom_left = 2
	style.corner_radius_bottom_right = 2
	style.content_margin_left = 3
	style.content_margin_right = 3
	style.content_margin_top = 2
	style.content_margin_bottom = 2
	quest_panel.add_theme_stylebox_override("panel", style)

	var vbox: VBoxContainer = VBoxContainer.new()

	# Quest name.
	var name_label: Label = Label.new()
	name_label.text = entry.get("name", "Unknown Quest")
	name_label.add_theme_font_size_override("font_size", 7)
	if entry.get("status", "") == "completed":
		name_label.add_theme_color_override("font_color", Color(0.4, 0.7, 0.4))
	else:
		name_label.add_theme_color_override("font_color", Color(0.9, 0.8, 0.3))
	vbox.add_child(name_label)

	# Description.
	var desc_label: Label = Label.new()
	desc_label.text = entry.get("description", "")
	desc_label.add_theme_font_size_override("font_size", 6)
	desc_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(desc_label)

	# Objectives.
	var objectives: Array = entry.get("objectives", [])
	for obj: Variant in objectives:
		var obj_label: Label = Label.new()
		var prefix: String = "[ ] " if entry.get("status", "") == "active" else "[x] "
		obj_label.text = prefix + str(obj)
		obj_label.add_theme_font_size_override("font_size", 6)
		obj_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.65))
		vbox.add_child(obj_label)

	# NPC name.
	var npc_id: String = entry.get("npc_id", "")
	if npc_id != "":
		var npc_label: Label = Label.new()
		npc_label.text = "NPC: %s" % npc_id.capitalize()
		npc_label.add_theme_font_size_override("font_size", 6)
		npc_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.6))
		vbox.add_child(npc_label)

	# Reward.
	var reward: String = entry.get("reward", "")
	if reward != "":
		var reward_label: Label = Label.new()
		reward_label.text = "Reward: %s" % reward
		reward_label.add_theme_font_size_override("font_size", 6)
		reward_label.add_theme_color_override("font_color", Color(0.6, 0.75, 0.5))
		vbox.add_child(reward_label)

	quest_panel.add_child(vbox)
	container.add_child(quest_panel)


func _on_quest_changed(_quest_id: String) -> void:
	if is_open:
		_refresh()
