extends Node

signal onlineSignal(value: Node)
signal freeInstanceSignal(value: Node)
signal popupSignal(value: String)
signal loadFileSignal(value: String)
signal saveFileSignal()
signal deleteFileSignal()
signal newFileSignal()
signal selectSaveSignal()
signal quitGameSignal(value: bool)
signal homeMenuSignal()
signal pauseMenuSignal()

func _ready() -> void:
	SignalManager.onlineSignal.connect(notify_online)
	SignalManager.freeInstanceSignal.connect(free_instance)
	SignalManager.quitGameSignal.connect(quit_game)
	SignalManager.popupSignal.connect(create_popup)
	SignalManager.onlineSignal.emit(self)
	return

func notify_online(value: Node) -> void:
	var node_name: String = value.name
	if SettingsManager.settings_file_contents.reportOnline.value == true:
		print_debug(node_name + " is online.")
	return

func free_instance(value: Node) -> void:
	var node_name: String = value.name
	if SettingsManager.settings_file_contents.reportOffline.value  == true:
		print_debug(node_name + " is being taken offline.")
	value.queue_free()
	return

func quit_game() -> void:
	print_debug('Quitting game.')
	get_tree().quit()
	return

func create_popup(value) -> void:
	print_debug('Creating a popup with the text ' + value)
	return
