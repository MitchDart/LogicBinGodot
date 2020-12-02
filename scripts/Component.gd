extends MeshInstance2D

signal on_drag(component)
signal on_output_click(component,index)
signal on_input_click(component,index)
signal on_output_hover(component,index, out)
signal on_input_hover(component,index, out)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mouse_body_hover = false;
var mouse_dragging = false;
var mouse_dragging_local_position = get_local_mouse_position();
	
onready var inputs = [get_node("InA"), get_node("InB")]
onready var outputs = [get_node("OutA")]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func get_input_position(index):
	return inputs[index].get_global_position()
	
func get_output_position(index):
	return outputs[index].get_global_position()
	

func _process(delta):
	if mouse_dragging:
		position = get_global_mouse_position() + mouse_dragging_local_position
		emit_signal("on_drag", self)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if mouse_body_hover && event.is_pressed():
				mouse_dragging_local_position = (position - get_global_mouse_position())
				self.mouse_dragging = true
				get_tree().set_input_as_handled()
			else:
				self.mouse_dragging = false
		if event.button_index == BUTTON_RIGHT && event.is_pressed():
			if mouse_body_hover:
				self.rotate(PI/2)
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
