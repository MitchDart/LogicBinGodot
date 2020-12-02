tool

extends Node2D

export var start_point = Vector2(0.0,0.0) setget set_startpoint
export var end_point = Vector2(0.0,0.0) setget set_endpoint

export var tension_start = 1.0 setget set_tension_start
export var tension_end = 1.0 setget set_tension_end

export var start_point_direction = 0.0 setget set_start_point_direction
export var end_point_direction = 0.0 setget set_end_point_direction

export var width = 10 
export var border_width = 5 

var curve = Curve2D.new()

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	
	var points = curve.tessellate()
	
	draw_polyline(points, Color.black, width, true)
	draw_polyline(points, Color.white, width - border_width, true)
