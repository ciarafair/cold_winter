extends Node

var game_manager: Node = null
var camera_position: Node = null

func _process(_delta: float) -> void:
	game_manager = find_game_manager()
	camera_position = find_camera_position()
	set_position()
	return

func find_game_manager():
	if game_manager != null:
		return game_manager
	var parent: Node = null
	parent = self.get_parent()
	if parent == null:
		push_error('Could not find the parent node for PlayerCamera.')
		return null
	var node = parent.get_parent()
	if node == null:
		push_error('Could not find the GameManager node for %s.' % parent.name)
		return null
	print_debug('Setting game_manager for PlayerCamera to %s.' % node.name)
	return node

func find_camera_position():
	var position: Node = null
	if game_manager == null:
		push_error('Could not find camera position as the game manager is not accessible.')
		find_game_manager()
		return null
	position = game_manager.current_camera_position
	if position == null:
		push_error('Could not find the current camera position from GameManager.')
		return null
	if position != camera_position:
		print_debug('Setting camera position for PlayerCamera to %s.' % position.name)
	return position

func set_position():
	if game_manager.is_paused == true:
		return
	if camera_position == null:
		find_camera_position()
		push_error('Could not set camera position as the camera position node is not accessible.')
		return
	set_location()
	set_rotation()
	return

func set_location() -> void:
	var node: Node = self
	if node.global_position == camera_position.global_position:
		return
	print_debug('Camera position: ' + str(node.global_position) + ' ' + 'Position location: ' + str(camera_position.global_position))
	node.global_position = camera_position.global_position
	print_debug('Updated camera position: ' + str(node.global_position) + ' ' + 'Updated position location: ' + str(camera_position.global_position))
	return

# This constantly produces output despite the camera being in the correct position, i'm not sure why.
func set_rotation() -> void:
	var node: Node = self
	if node.global_rotation == camera_position.global_rotation:
		return
	#print_debug('Camera rotation: ' + str(node.global_rotation) + ' ' + 'Position rotation: ' + str(camera_position.global_rotation))
	node.global_rotation = camera_position.global_rotation
	#print_debug('Updated camera rotation: ' + str(node.global_rotation) + ' ' + 'Updated position rotation: ' + str(camera_position.global_rotation))
	return
