extends Node
var interactable = null
var label: Label = null
var display: bool = false
var setting_type: String = ''
var setting_name: String = ''

func _ready() -> void:
	setting_name = self.get_meta('setting_name')
	return

func _process(_delta: float) -> void:
	find_nodes()
	display = self.get_meta('display')
	setting_type = self.get_meta('setting_type')
	self.visible = display
	return

func find_nodes() -> void:
	var container: HBoxContainer = get_node('HBoxContainer')
	find_label(container)
	find_interactable(container)


func find_label(node: Node) -> void:
	if self.label == null:
		#print_debug('Attempting to find label for setting %s.' % setting_name)
		label = node.get_node('Label')
		if label == null:
			push_error('Could not find label for setting %s.' % setting_name)
			return
		#print_debug('Found label for setting %s.' % setting_name)
		label.text = setting_name
		return

func find_interactable(node: Node) -> Node:
	if self.interactable == null:
		#print_debug('Attempting to find interactable for setting %s.' % setting_name)

		if setting_type == 'Checkbox':
			var checkbox: CheckBox = node.get_node('CheckBox')
			if checkbox == null:
				push_error('Could not find interactable for setting %s.' % setting_name)
				return
			#print_debug('Found interactable for setting %s.' % setting_name)
			interactable = checkbox
			if SettingsManager.settings_file_contents.has(setting_name):
				var setting_dictionary: Dictionary = SettingsManager.settings_file_contents.get(setting_name) 
				interactable.button_pressed = setting_dictionary.value
			return

		if setting_type == 'Slider':
			var slider: HSlider = node.get_node('HSlider')
			if slider == null:
				push_error('Could not find interactable for setting %s.' % setting_name)
				return
			#print_debug('Found interactable for setting %s.' % setting_name)
			interactable = slider
			if SettingsManager.settings_file_contents.has(setting_name):
				var setting_dictionary: Dictionary = SettingsManager.settings_file_contents.get(setting_name) 
				interactable.value = setting_dictionary.value
			return
	return

func _on_check_box_pressed() -> void:
	if SettingsManager.settings_file_contents.has(setting_name):
		var setting_dictionary: Dictionary = SettingsManager.settings_file_contents.get(setting_name) 
		setting_dictionary.value = !setting_dictionary.value
		if SettingsManager.settings_file_contents.reportSettingsUpdates.value  == true:
			print_debug('Changing the value of ' + setting_name + ' to ' + str(setting_dictionary.value))

func _on_h_slider_value_changed(value: float) -> void:
	if SettingsManager.settings_file_contents.has(setting_name):
		var setting_dictionary: Dictionary = SettingsManager.settings_file_contents.get(setting_name) 
		setting_dictionary.value = value
		if SettingsManager.settings_file_contents.reportSettingsUpdates.value  == true:
			print_debug('Changing the value of ' + setting_name + ' to ' + str(setting_dictionary.value))
