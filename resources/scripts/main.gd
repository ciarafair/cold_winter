extends Node

var homeMenuScene = load("res://scenes/menu/homeMenu.tscn")
var homeMenuInstance = homeMenuScene.instantiate()

#TODO:
# Home menu screen reminiscent of https://www.youtube.com/watch?v=xmZzderZV20 at 2:55

@onready var rootNode: Node = get_tree().root

func _ready() -> void:
	SignalManager.onlineSignal.emit(self)
	call_deferred("add_child", homeMenuInstance)
	return
