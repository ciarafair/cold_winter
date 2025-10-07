extends Node

var game_manager: Node = null
var is_visible: bool

func _ready() -> void:
    SignalManager.onlineSignal.emit(self)
    game_manager = find_game_manager()
    return

func _on_save_game_button_pressed() -> void:
    SignalManager.saveFileSignal.emit(SaveManager.save_file_location)
    return

func find_game_manager() -> Node:
    var node = self.get_parent()
    if node == null:
        push_error('Could not find the GameManager node for %s.' % self.name)
        return null
    game_manager = node
    return game_manager

func _on_settings_button_pressed() -> void:
    var parent_node: Node = self.get_parent()
    var scene = load("res://scenes/menu/settingsMenu.tscn")
    var instance = scene.instantiate()
    if parent_node == null:
        push_error('Could not load settings button as ' + self.name + ' has no parent node.')
        return
    parent_node.call_deferred("add_child", instance)
    SignalManager.freeInstanceSignal.emit(self)
    return

func _on_home_menu_button_pressed() -> void:
    SignalManager.homeMenuSignal.emit()
    return

func _process(_delta: float) -> void:
    is_visible = self.visible
    game_manager.is_paused = is_visible
    DialogueManager.is_paused = is_visible
    manage_input()
    return

func manage_input() -> void:
    if Input.is_action_just_released("toggle_menu"):
        self.visible = !is_visible
        if self.visible == false:
            SignalManager.unpause.emit()
    return
