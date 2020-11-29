extends MeshInstance2D

signal on_drag

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mouse_hover = false;
var mouse_dragging = false;
var mouse_dragging_local_position = get_local_mouse_position();

func get_input_A_position():
	return get_node("InA").global_position
	
func get_input_B_position():
	return get_node("InB").global_position
	
func get_output_A_position():
	return get_node("OutA").global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	if mouse_dragging:
		position = get_global_mouse_position() + mouse_dragging_local_position
		emit_signal("on_drag")


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if self.mouse_hover && event.is_pressed():
				mouse_dragging_local_position = (position - get_global_mouse_position())
				self.mouse_dragging = true
				get_tree().set_input_as_handled()
			else:
				self.mouse_dragging = false
		if event.button_index == BUTTON_RIGHT && event.is_pressed():
			if self.mouse_hover:
				self.rotate(PI/2)
				emit_signal("on_drag")


func _on_Area2D_mouse_entered():
	mouse_hover = true;


func _on_Area2D_mouse_exited():
	mouse_hover = false;
