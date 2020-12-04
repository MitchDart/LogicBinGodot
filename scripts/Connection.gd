const Wire = preload("res://scene/Wire.tscn")
const Component = preload("res://scripts/Component.gd")

class_name Connection

var wire : Wire
var input_component : Component
var output_component : Component
var input_component_IO_index = 0
var output_component_IO_index = 0
var scene

func _init(s):
	scene = s
	wire = Wire.instance()
	wire.z_index = 0
	scene.add_child(wire)

func set_input(ic, ii):
	input_component = ic
	input_component_IO_index = ii
	
func set_output(oc, oi):
	output_component = oc
	output_component_IO_index = oi

func wire_from_output_to_mouse():
	wire.start_point = output_component.get_output_position(0)
	wire.end_point = scene.get_global_mouse_position()
	wire.start_point_direction = output_component.rotation
	wire.end_point_direction = output_component.rotation
	wire.tension_start = 100
	wire.tension_end = 0
	
func wire_from_output_to_input():
	wire.start_point = output_component.get_output_position(output_component_IO_index)
	wire.start_point_direction = output_component.rotation
	wire.tension_start = 100
	wire.end_point = input_component.get_input_position(input_component_IO_index)
	wire.end_point_direction = input_component.rotation + PI*2
	wire.tension_end = 100

func destroy():
	scene.remove_child(wire)
