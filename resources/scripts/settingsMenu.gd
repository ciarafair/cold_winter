extends Node
var setting_num = 0

func _ready() -> void:
    SignalManager.homeMenuSignal.connect(return_to_home_menu)
    SignalManager.pauseMenuSignal.connect(return_to_pause_menu)
    SignalManager.onlineSignal.emit(self)
    return

func _process(_delta: float) -> void:
    enumerate_settings_buttons()
    return

func return_to_home_menu() -> void:
    var parent_node: Node = self.get_parent()
    var scene = preload("res://scenes/menu/homeMenu.tscn")
    var instance = scene.instantiate()
    if parent_node == null:
        SignalManager.popupSignal.emit('Could not load settings button as ' + self.name + ' has no parent node.')
        return
    parent_node.call_deferred("add_child", instance)
    SignalManager.freeInstanceSignal.emit(self)
    return

func return_to_pause_menu() -> void:
    var parent_node: Node = self.get_parent()
    var scene = preload("res://scenes/menu/pauseMenu.tscn")
    var instance = scene.instantiate()
    if parent_node == null:
        SignalManager.popupSignal.emit('Could not load settings button as ' + self.name + ' has no parent node.')
        return
    parent_node.call_deferred("add_child", instance)
    SignalManager.freeInstanceSignal.emit(self)
    return

func _on_save_changes_button_pressed() -> void:
    SettingsManager.save_file(SettingsManager.settings_location)
    return

func enumerate_settings_buttons() -> void:
    if setting_num < SettingsManager.settings_file_contents.size():
        for setting: String in SettingsManager.settings_file_contents:
            setting_num += 1
            var container: VBoxContainer = %SettingsContainer
            if container == null:
                push_error('Could not create setting %s as the settings VBoxContainer could not be found.' % setting)
                return
            var new_button = create_setting_button(setting)
            if new_button != null:
                container.add_child(new_button)
    return

func create_setting_button(setting) -> Node:
    var sample: MarginContainer = null
    var setting_dictionary = SettingsManager.settings_file_contents.get(setting)
    var display = setting_dictionary.get('display')
    var style: String = setting_dictionary.get('setting_style')

    if style == null:
        push_error('Style is null. Could not create setting button.')
        return null
    if display == null:
        push_error('Display is null. Could not create setting button.')
        return null

    if style == 'checkbox':
        sample = self.find_child('SampleCheckContainer')
    if style == 'slider':
        sample = self.find_child('SampleSliderContainer')

    if sample == null:
        push_error('Sample is null. Could not create setting button.')
        return null

    var new_button = sample.duplicate()

    new_button.name = setting + 'Setting'
    if SettingsManager.settings_file_contents.reportSettingsUpdates.value  == true:
        print_debug('Creating new button with meta the following meta. Style: ' + style + ', Display: ' + JSON.stringify(display) + ', Name: ' + setting)
    new_button.set_meta('setting_style1', style)
    new_button.set_meta('setting_name', setting)
    new_button.set_meta('display', display)
    return new_button
