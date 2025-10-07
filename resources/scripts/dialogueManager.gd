extends Node

@onready var textBoxScene: PackedScene = preload('res://scenes/world/text_box.tscn')

var dialogue_lines: Array[String] = []
var current_line_index: int = 0

var text_box: Node = null
var text_box_position: Vector2 = Vector2(0,0)

var is_dialogue_active: bool = false
var can_advance_line: bool = false

const default_position: Vector2 = Vector2(960, 100)

func _ready() -> void:
	SignalManager.textBoxFinish.connect(on_text_box_finish)
	return

func start_dialogue(position: Vector2, lines: Array[String]) -> void:
	if is_dialogue_active == true:
		return
	dialogue_lines = lines
	text_box_position = position
	show_text_box()

	is_dialogue_active = true
	return

func show_text_box() -> void:
	text_box = textBoxScene.instantiate()
	SignalManager.addTextBox.emit(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialogue_lines[current_line_index])
	can_advance_line = false
	return

func on_text_box_finish() -> void:
	can_advance_line = true
	return

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed('advance_dialogue') && is_dialogue_active && can_advance_line):
		text_box.queue_free()
		current_line_index += 1
		if current_line_index >= dialogue_lines.size():
			is_dialogue_active = false
			current_line_index = 0
			return
		show_text_box()
	return
