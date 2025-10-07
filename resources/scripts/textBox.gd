# Guide used: https://www.youtube.com/watch?v=1DRy5An_6DU

extends Node

@onready var label: RichTextLabel = $MarginContainer/RichTextLabel
@onready var timer: Timer = $Timer

const MAX_WIDTH = 256

var text: String = ''
var letter_index: int = 0

var letter_time: float = 0.03
var space_time: float  = 0.06
var punctuation_time: float = 0.2

func _process(_delta: float) -> void:
	if label != null:
		label.visible_characters = letter_index - 1
	if DialogueManager.is_paused == true:
		self.visible = false
	if DialogueManager.is_paused == false:
		self.visible = true
	return

func display_text(value: String) -> void:
	#print_debug('Displaying text with a value of %s.' % value)
	text = value
	label.text = value
	display_letter()
	return

func display_letter() -> void:
	if DialogueManager.is_paused == true:
		await SignalManager.unpause
	letter_index += 1

	if letter_index >= text.length():
		SignalManager.textBoxFinish.emit()
		return

	#print_debug('Displaying letter %s.' % text[letter_index])

	match text[letter_index]:
		'!', '.', ',', '?':
			timer.start(punctuation_time)
		' ':
			timer.start(space_time)
		_:
			timer.start(letter_time)
	return
