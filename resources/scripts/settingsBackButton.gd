extends Node

func _process(_delta: float) -> void:
	if SaveManager.is_file_loaded == false:
		self.text = 'Main Menu'
	if SaveManager.is_file_loaded == true:
		self.text = 'Pause Menu'
	return

func _on_pressed() -> void:
	if SaveManager.is_file_loaded == false:
		SignalManager.homeMenuSignal.emit()
	if SaveManager.is_file_loaded == true:
		SignalManager.pauseMenuSignal.emit()
