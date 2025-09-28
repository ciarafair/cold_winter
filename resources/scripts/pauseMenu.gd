extends Node

var is_visible: bool

func _ready() -> void:
	SignalManager.onlineSignal.emit(self)
	return

func _on_save_game_button_pressed() -> void:
	SignalManager.saveFileSignal.emit(FileManager.file_location)
	return

func _on_settings_button_pressed() -> void:
	return

func _on_home_menu_button_pressed() -> void:
	SignalManager.homeMenuSignal.emit()
	return

func _process(_delta: float) -> void:
	is_visible = self.visible
	manage_input()
	return

func manage_input() -> void:
	if Input.is_action_just_released("toggle_menu"):
		self.visible = !is_visible
	return
