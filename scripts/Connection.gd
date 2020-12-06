extends Node2D

const Component = preload("res://scripts/Component.gd")

signal on_click(connection)

class_name Connection 

export var selected = false setget set_selected

var input_component : Component
var output_component : Component
var input_component_IO_index = 0
var output_component_IO_index = 0

func set_selected(value):
	selected = value
	get_node("Wire").selected = value

func set_input(ic, ii):
	input_component = ic
	input_component_IO_index = ii
	
func set_output(oc, oi):
	output_component = oc
	output_component_IO_index = oi

func wire_from_output_to_mouse():
	get_node("Wire").start_point = output_component.get_output_position(0)
	get_node("Wire").end_point = get_global_mouse_position()
	get_node("Wire").start_point_direction = output_component.rotation
	get_node("Wire").end_point_direction = output_component.rotation
	get_node("Wire").tension_start = 100
	get_node("Wire").tension_end = 0
	
func wire_from_output_to_input():
	get_node("Wire").start_point = output_component.get_output_position(output_component_IO_index)
	get_node("Wire").start_point_direction = output_component.rotation
	get_node("Wire").tension_start = 100
	get_node("Wire").end_point = input_component.get_input_position(input_component_IO_index)
	get_node("Wire").end_point_direction = input_component.rotation + PI*2
	get_node("Wire").tension_end = 100

func _on_wire_click(wire):
	emit_signal("on_click", self)
