extends Node

var homeMenuScene = load("res://scenes/menu/homeMenu.tscn")
var homeMenuInstance = homeMenuScene.instantiate()

@onready var rootNode: Node = get_tree().root

func _ready() -> void:
	SignalManager.onlineSignal.emit(self)
	call_deferred("add_child", homeMenuInstance)
	return
