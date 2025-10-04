extends Node

var test_label: Label = null
var is_paused: bool = false
var camera_position_dictionary: Dictionary = {
	"main_camera_position": null,
	"current_camera_position": null
}

func _ready() -> void:
	SignalManager.homeMenuSignal.connect(returnToHomeMenu)
	SignalManager.newCameraPosition.connect(on_new_camera_position)
	SignalManager.onlineSignal.emit(self)
	return

func _process(_delta: float) -> void:
	find_unique_names()
	manage_input()
	var label_text: String = ''
	label_text = JSON.stringify(SaveManager.save_file_contents.test)
	if test_label != null:
		test_label.text = label_text
	return

func find_unique_names() -> void:
	var loop: int = 0
	if test_label == null:
		loop += 1
		if loop > 1:
			push_warning('Could not find node TestLabel. Attempting to add it via unique name.')
			return
		test_label = self.get_node('%TestLabel')
		loop = 0
		return
	return

func returnToHomeMenu() -> void:
	var parent_node: Node = self.get_parent()
	var scene = preload("res://scenes/menu/homeMenu.tscn")
	var instance = scene.instantiate()
	if parent_node == null:
		SignalManager.popupSignal.emit('Could not load settings button as ' + self.name + ' has no parent node.')
		return
	parent_node.call_deferred("add_child", instance)
	SignalManager.freeInstanceSignal.emit(self)
	SaveManager.is_file_loaded = false
	return

func manage_input() -> void:
	if Input.is_action_just_pressed("test_action"):
		#SaveManager.save_file_contents.test += 1
		return

func on_new_camera_position(node: Node):
	if is_paused == true:
		return
	if camera_position_dictionary.find_key(node) == null:
		var dictionary_number: int = camera_position_dictionary.size()
		var camera_position_number: int =  (dictionary_number - 2) + 1
		camera_position_dictionary[camera_position_number] = node
	camera_position_dictionary.current_camera_position = node
	#print_debug(camera_position_dictionary)
	#var node_name = node.name
	#print_debug('Setting new camera position to #%s.' % node_name)
	return
