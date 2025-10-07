extends Node
var is_hovered: bool = false
var panel: Panel = null

func _process(_delta: float) -> void:
    if panel == null:
        panel = find_panel()
        if panel == null:
            print_debug('Could not find panel.')
            return

    var hovered_style: StyleBoxFlat = load('res://resources/styles/main_menu_button_hovered.tres')
    var default_style: StyleBoxFlat = load('res://resources/styles/main_menu_button_default.tres')
    if is_hovered == true:
        panel.add_theme_stylebox_override('panel', hovered_style)
    if is_hovered == false:
        panel.add_theme_stylebox_override('panel', default_style)
    return

func find_panel() -> Panel:
    for child in self.get_children():
        if child is Panel:
            return child
    return

func _on_button_mouse_exited() -> void:
    #print_debug('Mouse exited %s.' % self.name)
    is_hovered = false
    return

func _on_button_mouse_entered() -> void:
    #print_debug('Mouse entered %s.' % self.name)
    is_hovered = true
    return