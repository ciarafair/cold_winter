extends Control

var save_file_container: Node = null
var button_num: int = 0

func _ready() -> void:
	FileManager.dir_contents()
	SignalManager.selectSaveSignal.connect(select_save)
	SignalManager.onlineSignal.emit(self)
	return

func _process(_delta: float) -> void:
	enumerate_save_buttons()
	return

func _on_new_game_button_pressed() -> void:
	var parent_node: Node = self.get_parent()
	var scene = preload("res://scenes/world/game.tscn")
	var instance = scene.instantiate()
	if parent_node == null:
		SignalManager.popupSignal.emit('Could not load settings button as ' + self.name + ' has no parent node.')
		return
	SignalManager.newFileSignal.emit(FileManager.file_location)
	parent_node.call_deferred("add_child", instance)
	SignalManager.freeInstanceSignal.emit(self)
	return

func select_save() -> void:
	var parent_node: Node = self.get_parent()
	var scene = preload("res://scenes/world/game.tscn")
	var instance = scene.instantiate()
	if parent_node == null:
		SignalManager.popupSignal.emit('Could not load settings button as ' + self.name + ' has no parent node.')
		return
	parent_node.call_deferred("add_child", instance)
	SignalManager.freeInstanceSignal.emit(self)
	return

func _on_main_menu_button_pressed() -> void:
	var parent_node: Node = self.get_parent()
	var scene = preload("res://scenes/menu/homeMenu.tscn")
	var instance = scene.instantiate()
	if parent_node == null:
		SignalManager.popupSignal.emit('Could not load settings button as ' + self.name + ' has no parent node.')
		return
	parent_node.call_deferred("add_child", instance)
	SignalManager.freeInstanceSignal.emit(self)
	return

func enumerate_save_buttons() -> void:
	var sample_container: CenterContainer = self.find_child('SampleFileContainer')
	if FileManager.known_files.size() > button_num:
		for key in FileManager.known_files:
			button_num += 1
			print_debug('Creating new save file button')
			var new_button: Node = create_save_button(button_num, sample_container)
			var container: VBoxContainer = %ButtonContainer
			if container == null:
				push_error('Could discover ButtonContainer in order to add new save file button.')
			container.add_child(new_button)
		return
	else:
		pass

func create_save_button(num: int, sample: Node) -> Node:
	if sample == null:
		push_error('Sample save file button is null.')
		return
	var new_button = sample.duplicate()
	new_button.name = 'FileContainer' + JSON.stringify(num)
	new_button.set_meta('file_location', FileManager.known_files.get(num))
	return new_button
