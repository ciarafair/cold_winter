class_name Interactable extends Node3D

@export var is_camera_position: bool = false
@export var is_dialogue_box: bool = false
@export var is_base_interactable: bool = false
@export var dialogue_text: Array[String] = []

var is_clickable: bool = false
var is_hovered: bool = false
var is_focused: bool = false
var has_been_clicked: bool = false

var camera_position: Node = null
@export var game_manager: Node = null
var interactable_children: Array[Node] = []
var mesh_instance_3d: MeshInstance3D = null
var highlight_shader_material: ShaderMaterial = load('res://resources/shaders/highlight_material.tres')

func _on_area_3d_mouse_entered() -> void:
	self.is_hovered = true
	SignalManager.hoveringClickable.emit(self)
	#print_debug('Setting is_hovered for ' + self.name + ' to ' + str(is_hovered) + '.')
	return

func _on_area_3d_mouse_exited() -> void:
	self.is_hovered = false
	SignalManager.hoveringClickable.emit(self)
	#print_debug('Setting is_hovered for ' + self.name + ' to ' + str(is_hovered) + '.')
	return

func _process(_delta: float) -> void:
	if self.game_manager == null:
		push_error('%s has not had the game manager assigned.' % self.name)

	if self.game_manager.is_paused == true:
		return

	if self.interactable_children == []:
		find_interactable_children()

	if game_manager.focused_interactable == self:
		self.is_focused = true
	if game_manager.focused_interactable == self:
		self.is_focused = false

	if self.is_base_interactable == true:
		var current_camera_position: Node = null
		var main_camera_position: Node = null

		if game_manager.camera_position_dictionary.get('current_camera_position') != null:
			current_camera_position = game_manager.camera_position_dictionary.get('current_camera_position')
		if game_manager.camera_position_dictionary.get('main_camera_position') != null:
			main_camera_position = game_manager.camera_position_dictionary.get('main_camera_position')

		if main_camera_position != null:
			if current_camera_position != null:
				if current_camera_position == main_camera_position:
					self.is_clickable = true
				if current_camera_position != main_camera_position:
					self.is_clickable = false

	if self.mesh_instance_3d == null:
		find_mesh_instance_3d()

	if self.is_hovered == true:
		manage_input()
		if self.is_clickable == true:
			#print_debug('Setting material override for mesh %s.' % mesh_instance_3d)
			self.mesh_instance_3d.material_overlay = highlight_shader_material

	if self.is_hovered == false or self.is_clickable == false or DialogueManager.is_dialogue_active == true:
		self.mesh_instance_3d.material_overlay = null

	if self.is_camera_position == true:
		find_camera_position()
	while_current_camera_position()
	return

func manage_input() -> void:
	if Input.is_action_just_pressed("left_click"):
		if self.is_clickable == false:
			return
		if DialogueManager.is_dialogue_active == true:
			return
		if self.has_been_clicked == true:
			return
		SaveManager.save_file_contents.test += 1
		#print_debug('Clicking on %s.' % self.name)
		if self.is_focused != true:
			if self.is_camera_position == true:
				if self.camera_position == null:
					push_error('Could not set new camera position as %s could not find it.' % self.name)
					return
				SignalManager.newCameraPosition.emit(self.camera_position)
				if self.is_dialogue_box == true:
					DialogueManager.start_dialogue(DialogueManager.default_position, self.dialogue_text, self)
					return
				return

		if self.is_dialogue_box == true:
			self.is_clickable = false
			if self.dialogue_text == []:
				push_error('Dialogue interactable %s does not have any dialogue written.' % self.name)
				return
			DialogueManager.start_dialogue(DialogueManager.default_position, self.dialogue_text, self)
			return
	return

func find_camera_position() -> void:
	var node: Node = self.find_child('CameraPosition')
	if node == null:
		push_error('Could not find camera position for interactable %s.' % self.name)
		return
	self.camera_position = node
	return

func find_mesh_instance_3d() -> void:
	var node: Node = self.find_child('MeshInstance3D')
	if node == null:
		push_error('Could not find camera position for interactable %s.' % self.name)
		return
	self.mesh_instance_3d = node
	return

func find_interactable_children() -> void:
	for child in self.get_children():
		#print_debug('Adding child %s to interactble list.' % child.name)
		if child is Interactable:
			self.interactable_children.append(child)
			#print_debug(self.name + ' has the interactable children of: ' + str(interactable_children))
	return

func while_current_camera_position() -> void:
	if self.game_manager.camera_position_dictionary['current_camera_position'].get_parent() == self:
		for child in self.interactable_children:
			#print_debug('Setting %s.isclickable to true.' % child.name)
			child.is_clickable = true
	else:
		for child in self.interactable_children:
			#print_debug('Setting %s.isclickable to false.' % child.name)
			child.is_clickable = false
