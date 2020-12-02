tool

extends Node2D

const WIRE = preload("res://scene/Wire.tscn")

var creating_connection = null
var connections = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _input(event):
	if creating_connection != null && event is InputEventMouseMotion && creating_connection.input_component == null:
		set_creating_wire_to_mouse()
	elif creating_connection != null && event is InputEventMouseButton && event.is_pressed():
		remove_child(creating_connection.wire)
		creating_connection = null

func _on_component_drag(component):
	for connection in connections:
		if connection.input_component == component || connection.output_component == component:
			connection.wire.start_point = connection.output_component.get_output_position(connection.output_component_IO_index)
			connection.wire.start_point_direction = connection.output_component.rotation
			connection.wire.tension_start = 70
			
			connection.wire.end_point = connection.input_component.get_input_position(connection.input_component_IO_index)
			connection.wire.end_point_direction = connection.input_component.rotation + PI*2
			connection.wire.tension_end = 70


#Need to check if the input is not already occupied
func _on_component_input_click(component, index):
	if creating_connection != null:
		if is_input_occupied(component, index):
			return
		connections.push_back(creating_connection)
		creating_connection = null
		
func is_input_occupied(component, index):
	for connection in connections:
		if connection.input_component == component:
			if connection.input_component_IO_index == index:
				return true
	return false

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
		if !out && !is_input_occupied(component,index): 
			creating_connection.input_component = component
			creating_connection.input_component_IO_index = index
			creating_connection.wire.end_point = creating_connection.input_component.get_input_position(index)
			creating_connection.wire.end_point_direction = creating_connection.input_component.rotation + PI*2
			creating_connection.wire.tension_end = 70
		else:
			creating_connection.input_component = null

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
