extends Node
var game_manager: Node = self.get_parent()
var control: Node = null
var is_hovered: bool = false

func _process(_delta: float) -> void:
	calculate_is_hovered()
	find_control()
	manage_input()
	return

func calculate_is_hovered() -> void:
	if game_manager == null:
		return
	if game_manager.is_paused == true:
		return
	if get_viewport().get_mouse_position().y < get_viewport().size.y / 1.125:
		is_hovered = false
	else:
		is_hovered = true

func find_game_manager() -> void:
	if game_manager == null:
		game_manager = self.get_parent()
	return

func find_control() -> void:
	if self.get_child(0) == null:
		push_error('Could not find control node for %s' % self.name)
		return
	if control == null:
		control = self.get_child(0)
	if game_manager == null:
		find_game_manager()
		return
	if game_manager.current_camera_position != game_manager.main_camera_position:
		control.visible = is_hovered
	else: 
		control.visible = false
	return

func manage_input() -> void:
	if is_hovered == true:
		if Input.is_action_just_pressed("left_click"):
			print_debug('Moving to last camera position.')
			SignalManager.newCameraPosition.emit(game_manager.main_camera_position)
			is_hovered = false
			return
	return
