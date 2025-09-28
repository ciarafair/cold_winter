extends Node

func _ready() -> void:
	SignalManager.onlineSignal.emit(self)
	return

func _on_home_menu_button_pressed() -> void:
	var parent_node: Node = self.get_parent()
	var scene = preload("res://scenes/menu/homeMenu.tscn")
	var instance = scene.instantiate()
	if parent_node == null:
		SignalManager.popupSignal.emit('Could not load settings button as ' + self.name + ' has no parent node.')
		return
	parent_node.call_deferred("add_child", instance)
	SignalManager.freeInstanceSignal.emit(self)
	return
