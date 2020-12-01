tool

extends Node2D

const WIRE = preload("res://scene/Wire.tscn")

var creating_connection = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _input(event):
	if creating_connection != null && event is InputEventMouseMotion && creating_connection.input_component == null:
		set_creating_wire_to_mouse()
	elif creating_connection != null && event is InputEventMouseButton && event.is_pressed():
		remove_child(creating_connection.wire)
		creating_connection = null

func set_wire(wire):
	wire.start_point = get_node("AndGate").get_output_position(0)
	wire.end_point = get_node("XNorGate").get_input_position(0)
	wire.start_point_direction = get_node("AndGate").rotation_degrees
	wire.end_point_direction = get_node("XNorGate").rotation_degrees


func _on_component_drag(component):
	pass


func _on_component_input_click(component, index):
	pass # Replace with function body.


func _on_component_output_click(component, index):
	if creating_connection == null:
		var wire = WIRE.instance()
		wire.z_index = 0
		creating_connection = Connection.new()
		creating_connection.wire = wire
		creating_connection.output_component = component
		creating_connection.output_component_IO_index = index
		add_child(wire)
		set_creating_wire_to_mouse()

func _on_component_input_hover(component, index, out):
	if creating_connection != null:
		if !out: 
			creating_connection.input_component = component
			creating_connection.wire.end_point = creating_connection.input_component.get_input_position(index)
			creating_connection.wire.end_point_direction = creating_connection.input_component.rotation + PI*2
			creating_connection.wire.tension_end = 70
		else:
			creating_connection.input_component = null
			creating_connection.wire.end_point = get_global_mouse_position()
			creating_connection.wire.end_point_direction = creating_connection.output_component.rotation
			creating_connection.wire.tension_end = 0

func set_creating_wire_to_mouse():
		creating_connection.wire.start_point = creating_connection.output_component.get_output_position(0)
		creating_connection.wire.end_point = get_global_mouse_position()
		creating_connection.wire.start_point_direction = creating_connection.output_component.rotation
		creating_connection.wire.end_point_direction = creating_connection.output_component.rotation
		creating_connection.wire.tension_start = 70
		creating_connection.wire.tension_end = 0

class Connection:
	var wire
	var input_component
	var output_component 
	var input_component_IO_index
	var output_component_IO_index
