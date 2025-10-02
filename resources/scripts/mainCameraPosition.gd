extends Node
var game_manager: Node = null

func _ready() -> void:
    SignalManager.onlineSignal.emit(self)
    return

func _process(_delta: float) -> void:
    game_manager = find_game_manager()
    game_manager.main_camera_position = self
    if game_manager.current_camera_position == null:
        SignalManager.newCameraPosition.emit(self)
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
