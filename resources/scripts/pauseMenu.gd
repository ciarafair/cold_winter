extends Node

var is_visible: bool

func _ready() -> void:
	SignalManager.onlineSignal.emit(self)
	return

func _on_save_game_button_pressed() -> void:
	SignalManager.saveFileSignal.emit(SaveManager.save_file_location)
	return

func _on_settings_button_pressed() -> void:
	var parent_node: Node = self.get_parent()
	var scene = load("res://scenes/menu/settingsMenu.tscn")
	var instance = scene.instantiate()
	if parent_node == null:
		SignalManager.popupSignal.emit('Could not load settings button as ' + self.name + ' has no parent node.')
		return
	parent_node.call_deferred("add_child", instance)
	SignalManager.freeInstanceSignal.emit(self)
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
