extends Node

func _ready():
	SignalManager.onlineSignal.emit(self)
	return

func _on_select_save_button_pressed() -> void:
	var parent_node: Node = self.get_parent()
	var scene = load("res://scenes/menu/savesMenu.tscn")
	var instance = scene.instantiate()
	if parent_node == null:
		SignalManager.popupSignal.emit('Could not load settings button as ' + self.name + ' has no parent node.')
		return
	parent_node.call_deferred("add_child", instance)
	SignalManager.freeInstanceSignal.emit(self)
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

func _on_quit_game_button_pressed() -> void:
	SignalManager.quitGameSignal.emit()
	return
