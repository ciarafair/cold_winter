extends Node
var is_hovered: bool = false
var camera_position: Node = null
var is_camera_position: bool = false

func _on_area_3d_mouse_entered() -> void:
    is_hovered = true 
    SignalManager.hoveringClickable.emit(self)
    #print_debug('Setting is_hovered for ' + self.name + ' to ' + str(is_hovered) + '.')
    return

func _on_area_3d_mouse_exited() -> void:
    is_hovered = false 
    SignalManager.hoveringClickable.emit(self)
    #print_debug('Setting is_hovered for ' + self.name + ' to ' + str(is_hovered) + '.')
    return

func _process(_delta: float) -> void:
    is_camera_position = self.get_meta('is_camera_position')
    if is_hovered == true:
        manage_input()
        return
    if is_camera_position == true:
        find_camera_position()
    return

func manage_input() -> void:
    if Input.is_action_just_pressed("left_click"):
        SaveManager.save_file_contents.test += 1
        #print_debug('Clicking on %s.' % self.name)
        if self.get_meta('is_camera_position') == true:
            if self.camera_position == null:
                push_error('Could not set new camera position as %s could not find it.' % self.name)
                return
            SignalManager.newCameraPosition.emit(self.camera_position)
        return
    return

func find_camera_position() -> void:
    var node: Node = self.find_child('CameraPosition')
    if node == null:
        push_error('Could not find camera position for interactable %s.' % self.name)
        return
    camera_position = node
    return