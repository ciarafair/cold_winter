extends Node

func _ready() -> void:
	SignalManager.hoveringClickable.connect(on_hovered_clickable)
	return

func on_hovered_clickable(node: Node):
	var node_name = node.name
	var node_hovered = node.is_hovered
	var value: String = str(node_name) + '.' + str(node_hovered)
	self.text = value
	return
