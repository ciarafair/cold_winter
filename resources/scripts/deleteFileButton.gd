extends Button

func _on_pressed() -> void:
	print_debug('Deleting save file.')
	SignalManager.deleteFileSignal.emit(FileManager.file_location)
	return