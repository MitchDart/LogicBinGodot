tool

extends Node2D

class_name Wire

signal on_click(wire)

const ON_COLOR = Color("d2d000")
const OFF_COLOR = Color("ffffff")

const OFF_TEXTURE = preload("res://images/wire.svg")
const ON_TEXTURE = preload("res://images/wire_on.svg")

export var start_point = Vector2(0.0,0.0) setget set_startpoint
export var end_point = Vector2(0.0,0.0) setget set_endpoint

export var tension_start = 1.0 setget set_tension_start
export var tension_end = 1.0 setget set_tension_end

export var start_point_direction = 0.0 setget set_start_point_direction
export var end_point_direction = 0.0 setget set_end_point_direction

export var selected = false setget set_selected
export var on = false setget set_on

export var width = 10 setget set_width
export var border = 5 setget set_border

var curve = Curve2D.new()

func set_selected(new_selected):
	if selected != new_selected:
		selected = new_selected
		get_node("Select").visible = selected
	

func set_startpoint(new_startpoint):
	if start_point != new_startpoint:
		start_point = new_startpoint
		update()

func set_endpoint(new_endpoint):
	if end_point != new_endpoint:
		end_point = new_endpoint
		update()
		
func set_tension_start(new_tension):
	if tension_start != new_tension:
		tension_start = new_tension
		update()
		
func set_tension_end(new_tension):
	if tension_end != new_tension:
		tension_end = new_tension
		update()
		
func set_start_point_direction(new_start_point_direction):
	if start_point_direction != new_start_point_direction:
		start_point_direction = new_start_point_direction
		update()
		
func set_end_point_direction(new_end_point_direction):
	if end_point_direction != new_end_point_direction:
		end_point_direction = new_end_point_direction
		update()
		
func set_border(new_border):
	border = new_border
	update()
	
func set_width(new_width):
	width = new_width
	update()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func set_on(value):
	if value != on:
		on = value
		set_texture()
		
func set_texture():
	if on:
		get_node("Line").texture = ON_TEXTURE
	else:
		get_node("Line").texture = OFF_TEXTURE

func _draw():
	var clamped_tension_start = min(tension_start, start_point.distance_to(end_point))
	var clamped_tension_end = min(tension_end, start_point.distance_to(end_point))
	
	var cp1 = Transform2D.IDENTITY
	cp1 = cp1.rotated(start_point_direction).translated(Vector2(0.0,clamped_tension_start))
	var cp2 = Transform2D.IDENTITY
	cp2 = cp2.rotated(end_point_direction).translated(Vector2(0.0,-clamped_tension_end))
	
	var inA = Vector2(0.0,0.0)
	var inB = cp2.xform(Vector2(0.0,0.0))
	var outA = cp1.xform(Vector2(0.0,0.0))
	var outB = Vector2(0.0,0.0)
	
	curve.clear_points()
	curve.add_point(start_point, inA, outA)
	curve.add_point(end_point, inB, outB)
	
	var points = curve.tessellate(6,2)
	get_node("Select").points = points
	get_node("Line").points = points
	
func _unhandled_input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
		var closest_point = curve.get_closest_point(get_local_mouse_position())
		var distance_to_mouse = closest_point.distance_to(get_local_mouse_position())
		if distance_to_mouse < border:
			emit_signal("on_click", self)
			get_tree().set_input_as_handled()
