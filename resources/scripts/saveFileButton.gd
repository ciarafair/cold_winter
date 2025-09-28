extends Node

func _ready() -> void:
	var parent = get_node('../../')
	self.text = "Save File #" + find_number(parent.get_meta('file_location'))
	return

func _on_pressed() -> void:
	FileManager.dir_contents()
	SignalManager.loadFileSignal.emit(get_node('../../').get_meta('file_location'))
	SignalManager.selectSaveSignal.emit()
	return

func find_number(value: String) -> String:
	var key = FileManager.known_files.find_key(value)
	print_debug('Setting button number to ' + JSON.stringify(key))
	return JSON.stringify(key)
