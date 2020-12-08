extends Node2D

#Gate scene declaration
const ANDGATE = preload("res://scene/AndGate.tscn")
const XNORGATE = preload("res://scene/XNorGate.tscn")
const CONNECTION = preload("res://scene/Connection.tscn")
const SWITCH = preload("res://scene/Switch.tscn")
const LIGHT = preload("res://scene/Light.tscn")

#Current creating connection state
var creating_connection = null

#Current creating component state
var creating_component = null

#List of active current connections
var connections = []

#List of active components
var components = []

#Current selected component state
var selected_component = null

#Current selected connection state
var selected_connection = null

#--- Events ----

# Called every frame to set states of all components
func _process(delta):
	for connection in connections:
		var from_component = connection.output_component
		from_component.outputs[connection.output_component_IO_index].on = from_component.on
		connection.on = from_component.on
		var to_component = connection.input_component
		to_component.inputs[connection.input_component_IO_index].on = from_component.on


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called on any input from user
func _input(event):
	if event is InputEventKey && event.is_pressed():
		reset_creating_component()
		reset_creating_connection()
	# if we are creating a component at the time handle accordingly
	if creating_component != null:
		on_input_while_creating_component(event)
	# if we are creating a connection at the time handle accordingly
	elif creating_connection != null:
		on_input_while_creating_connection(event)
	# Create gates
	elif event is InputEventKey && event.scancode == KEY_1 && event.is_pressed():
		spawn_and_gate()
	elif event is InputEventKey && event.scancode == KEY_2 && event.is_pressed():
		spawn_xnor_gate()
	elif event is InputEventKey && event.scancode == KEY_3 && event.is_pressed():
		spawn_switch()
	elif event is InputEventKey && event.scancode == KEY_4 && event.is_pressed():
		spawn_light()
	elif event is InputEventKey && event.scancode == KEY_DELETE && event.is_pressed():
		if selected_connection != null:
			delete_connection(selected_connection)
		if selected_component != null:
			delete_component(selected_component)

func _unhandled_input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
		reset_selected_states()

# Called when any component is clicked on
func _on_component_click(component):
	reset_selected_states()
	component.selected = true
	selected_component = component
	for connection in search_for_connections(component):
		connection.selected = true

# Called when any component is dragged around the scene
func _on_component_drag(component):
	# Find and connections for that component
	var found_connections = search_for_connections(component)
	# For each of the connections draw the wire between the two components
	for connection in found_connections:
		connection.wire_from_output_to_input()
	
# Called when a component input is clicked
func _on_component_input_click(component, index):
	# If we are creating a connection then complete it
	if creating_connection != null:
		complete_new_connection(component, index)
		
# Called when a component output is clicked
func _on_component_output_click(component, index):
	# If we are NOT creating a connection then start doing so
	if creating_connection == null:
		create_new_connection(component, index)

# Called when we hover over an input
func _on_component_input_hover(component, index, out):
	# If we are busy creating a connection check set the input if we hover in else reset it if we hover out
	if creating_connection != null:
		if !out && !is_input_occupied(component,index): 
			creating_connection.set_input(component,index)
			creating_connection.wire_from_output_to_input()
		else:
			creating_connection.set_input(null,0)
			
# Called if a user inputs while creating a connection
func on_input_while_creating_connection(event):
	# If the user moves the mouse with no input connection then draw wire to mouse
	if event is InputEventMouseMotion && creating_connection.input_component == null:
		creating_connection.wire_from_output_to_mouse()
	# If the user clicks on anything else destroy the connection
	elif event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
		reset_creating_connection()
		get_tree().set_input_as_handled()

func reset_creating_connection():
	remove_child(creating_connection)
	creating_connection = null
	enable_only_ouputs()
	
#Called if a user inputs while creating a component	
func on_input_while_creating_component(event):
	if event is InputEventMouseMotion:
		creating_component.position = get_global_mouse_position()
	elif event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
		complete_new_component()
		get_tree().set_input_as_handled()
		
func reset_creating_component():
	remove_child(creating_component)
	creating_component = null

#--- Connections ----

# Creates a new connection and stores it globally
func create_new_connection(component, index):
	creating_connection = CONNECTION.instance()
	add_child(creating_connection)
	creating_connection.set_output(component,index)
	creating_connection.wire_from_output_to_mouse()
	enable_only_unoccupied_inputs()

# Completes the new connection and stores it in the connections array
func complete_new_connection(component, index):
	if is_input_occupied(component, index):
		return
	creating_connection.connect("on_click", self, "_on_connection_click")
	creating_connection.set_input(component,index)
	creating_connection.wire_from_output_to_input()
	connections.push_back(creating_connection)
	creating_connection = null
	enable_only_ouputs()
	
# Searches for all connections associated with a component
func search_for_connections(component):
	var found_connections = []
	for connection in connections:
		if connection.input_component == component || connection.output_component == component:
			found_connections.push_back(connection)
	return found_connections
	
# Called when any connection is clicked on
func _on_connection_click(connection):
	reset_selected_states()
	connection.selected = true
	selected_connection = connection
	
# When a connection is deleted
func delete_connection(connection):
	connections.remove(connections.find(connection))
	remove_child(connection)
	reset_selected_states()

#--- Components ----

# Setup component by connecting signals and dropping onto canvas
func complete_new_component():
	creating_component.connect("on_click", self, "_on_component_click")
	creating_component.connect("on_drag", self, "_on_component_drag")
	creating_component.connect("on_input_click", self,"_on_component_input_click")
	creating_component.connect("on_input_hover", self, "_on_component_input_hover")
	creating_component.connect("on_output_click", self, "_on_component_output_click")
	creating_component.enabled = true
	components.push_back(creating_component)
	creating_component = null
	enable_only_ouputs()
	
# Create new component and store it on creating component
func create_new_component(component : Component):
	component.z_index = 5
	component.rotation_degrees = -90
	component.position = get_global_mouse_position()
	add_child(component)
	creating_component = component

# Create an AndGate
func spawn_and_gate():
	var andGate = ANDGATE.instance()
	create_new_component(andGate)
	
# Create an XNorGate
func spawn_xnor_gate():
	var xnorGate = XNORGATE.instance()
	create_new_component(xnorGate)
	
func spawn_switch():
	var switch = SWITCH.instance()
	create_new_component(switch)
	
func spawn_light():
	var light = LIGHT.instance()
	create_new_component(light)
	
# When a connection is deleted
func delete_component(component):
	components.remove(components.find(component))
	remove_child(component)
	var found_connections = search_for_connections(component)
	for connection in found_connections:
		delete_connection(connection)
	reset_selected_states()

#--- Utilites ----

# Return true if a component input index is occupied
func is_input_occupied(component, index):
	for connection in connections:
		if connection.input_component == component:
			if connection.input_component_IO_index == index:
				return true
	return false

func enable_only_unoccupied_inputs():
	for component in components:
		for output in component.outputs:
			output.enabled = false
		for i in component.inputs.size():
			if !is_input_occupied(component, i):
				component.inputs[i].enabled = true
	
func enable_only_ouputs():
	for component in components:
		for input in component.inputs:
			input.enabled = false
		for output in component.outputs:
			output.enabled = true
			
func reset_selected_states():
	if selected_component != null: 
		selected_component.selected = false
		for connection in search_for_connections(selected_component):
			connection.selected = false
		selected_component = null
	if selected_connection != null:
		selected_connection.selected = false
		selected_connection = null
