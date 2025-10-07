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
    if game_manager.camera_position_dictionary.current_camera_position != game_manager.camera_position_dictionary.main_camera_position:
        control.visible = is_hovered
    else:
        control.visible = false
    return

func manage_input() -> void:
    if is_hovered == true:
        if Input.is_action_just_pressed("left_click"):
            #print_debug('Moving to last camera position.')
            var dictionary_number: int = game_manager.camera_position_dictionary.size()
            var camera_position_number: int =  dictionary_number - 3
            if camera_position_number >= 1:
                var new_camera_position: Node = null
                if game_manager.camera_position_dictionary.current_camera_position != null:
                    var current_camera_position: Node = game_manager.camera_position_dictionary.current_camera_position
                    var interactable: Node = current_camera_position.get_parent()
                    interactable.is_clickable = true
                    new_camera_position = game_manager.camera_position_dictionary.get(camera_position_number)
                    #print_debug('Found previous camera position. Setting new position to camera position #%s.' % camera_position_number)
                    SignalManager.newCameraPosition.emit(new_camera_position)
                    remove_camera_position_from_dictionary()
                    is_hovered = false

                    return
            remove_camera_position_from_dictionary()
            is_hovered = false
            game_manager.focused_interactable = null
            SignalManager.newCameraPosition.emit(game_manager.camera_position_dictionary.main_camera_position)
            return
    return

func remove_camera_position_from_dictionary():
    var dictionary_number: int = game_manager.camera_position_dictionary.size()
    var camera_position_number: int =  dictionary_number - 2
    #print_debug('Attempting to remove camera position #%s from dictionary.' % camera_position_number)
    game_manager.camera_position_dictionary.erase(camera_position_number)
    if game_manager.camera_position_dictionary.get(camera_position_number) != null:
        push_error('Could not remove camera position #%s from dictionary.' % camera_position_number)
    return