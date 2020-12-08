extends Node2D

class_name Component

signal on_drag(component)
signal on_output_click(component,index)
signal on_input_click(component,index)
signal on_output_hover(component,index, out)
signal on_input_hover(component,index, out)
signal on_click(component)
signal logic_state_changed(component)

export var enabled = false;
export var selected = false setget set_selected;
export var on = false setget set_on;

var mouse_body_hover = false;
var mouse_dragging = false;
var mouse_dragging_local_position = get_local_mouse_position();
var mouse_dragging_global_position = get_global_mouse_position();
	
var inputs = []
var outputs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is IO:
			if child.is_output:
				if outputs.size() < child.index + 1:
					outputs.resize(child.index + 1)
				outputs[child.index] = child
			else:
				if inputs.size() < child.index + 1:
					inputs.resize(child.index + 1)
				inputs[child.index] = child
	
func get_input_position(index):
	return inputs[index].get_global_position()
	
func get_output_position(index):
	return outputs[index].get_global_position()

func _input(event):
	if enabled && event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if mouse_body_hover && event.is_pressed():
				mouse_dragging_local_position = (position - get_global_mouse_position())
				mouse_dragging_global_position = get_global_mouse_position()
				self.mouse_dragging = true
				get_tree().set_input_as_handled()
			else:
				if mouse_dragging_global_position.distance_to(get_global_mouse_position()) < 5:
					emit_signal("on_click", self)
					get_tree().set_input_as_handled()
				self.mouse_dragging = false
	if event is InputEventMouseButton && event.button_index == BUTTON_RIGHT && event.is_pressed():
		if mouse_body_hover:
			self.rotate(PI/2)
			emit_signal("on_drag", self)
			get_tree().set_input_as_handled()
	if event is InputEventMouseMotion && mouse_dragging:
		position = get_global_mouse_position() + mouse_dragging_local_position
		emit_signal("on_drag", self)
		get_tree().set_input_as_handled()


func _on_Area2D_mouse_entered():
	mouse_body_hover = true;

func _on_Area2D_mouse_exited():
	mouse_body_hover = false;

func _on_io_click(io):
	if io.is_output:
		emit_signal("on_output_click",self , io.index)
	else:
		emit_signal("on_input_click",self, io.index)

func _on_io_hover(io, out):
	if io.is_output:
		emit_signal("on_output_hover",self , io.index, out)
	else:
		emit_signal("on_input_hover",self, io.index, out)
		
func set_selected(value):
	selected = value
	var selected_node = get_node("Selected")
	if selected_node != null:
		selected_node.visible = selected
		
func set_on(value):
	if on != value:
		on = value
		emit_signal("logic_state_changed", self)
