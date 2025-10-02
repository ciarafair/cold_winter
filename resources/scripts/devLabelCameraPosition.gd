extends Node
var game_manager: Node = null

func _ready() -> void:
	find_game_manager()
	return

func _process(_delta: float) -> void:
	check_camera_position()
	return

func find_game_manager() -> void:
	var node = get_node('../../..')
	if node == null:
		print_debug('Could not find DaveLabels node for %s as node is null.' % self.name)
		return
	var node_parent = node.get_parent()
	if node_parent == null:
		print_debug('Could not find GameManager for %s as node is null.' % self.name)
	game_manager = node_parent
	return

func check_camera_position() -> void:
	var node: Node = game_manager.current_camera_position
	if node == null:
		print_debug('Could not find current camera position for %s as node is null.' % self.name)
		return
	var node_name: String = node.name
	var node_parent: Node = node.get_parent()
	if node_parent == null:
		print_debug('Could not find current camera positions parent for %s as node is null.' % self.name)
	var node_parent_name: String = node_parent.name
	var value: String = str(node_parent_name) + '.' + str(node_name)
	self.text = value
	return
