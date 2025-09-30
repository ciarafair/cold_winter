extends Node

func _ready() -> void:
	var parent = get_node('../../')
	self.text = "Save File #" + find_number(parent.get_meta('save_file_location'))
	return

func _on_pressed() -> void:
	var container: Node = get_node('../../')
	SaveManager.dir_contents()
	if container == null:
		push_error('Could not use save button as the container is null.')
		return
	SignalManager.loadFileSignal.emit(container.get_meta('save_file_location'))
	SignalManager.selectSaveSignal.emit()
	return

func find_number(value: String) -> String:
	var key = SaveManager.known_files.find_key(value)
	if SettingsManager.settings_file_contents.reportSaveFileUpdates.value  == true:
		print_debug('Setting button number to ' + JSON.stringify(key))
	return JSON.stringify(key)
