extends Node

var game_manager: Node = null

func _ready() -> void:
    find_game_manager()
    return

func _process(_delta: float) -> void:
    set_focused_interactable()
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

func set_focused_interactable() -> void:
    if game_manager.focused_interactable != null:
        self.text = game_manager.focused_interactable.name
        return
    self.text = 'Null'
    return