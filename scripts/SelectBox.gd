tool

extends Node2D
class_name SelectBox

signal on_component_selected(component)
signal on_component_deselected(component)

var mouse_drag = false
onready var mouse_start = get_local_mouse_position()
var mouse_pos = Vector2(0, 0)

export var collision_check_interval = 10
export var collision_check_counter = 0

export var colour_fill: Color = Color(0.0, 0.0, 1.0, 0.1) setget set_colour_fill
export var colour_border: Color = Color(0.0, 0.0, 1.0, 1.0) setget set_colour_border
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(0, 0, 100, 100), colour_fill)
		draw_rect(Rect2(0, 0, 100, 100), colour_border, false)
	else:		
		draw_rect(Rect2(mouse_start, mouse_pos - mouse_start), colour_fill)
		draw_rect(Rect2(mouse_start, mouse_pos - mouse_start), colour_border, false)
			
func _process(delta):
		mouse_pos = get_local_mouse_position() 
		update()

func _physics_process(delta):
	collision_check_counter += 1
	if collision_check_counter % collision_check_interval == 0:
		var collision_polygon = get_node("Area2D/CollisionPolygon2D")
		var top_left = mouse_start
		var top_right = Vector2(mouse_pos.x, mouse_start.y)
		var bottom_right = Vector2(mouse_pos.x,  mouse_pos.y)
		var bottom_left = Vector2(mouse_start.x, mouse_pos.y)
		var point_array = []
		point_array.push_back(top_left)
		point_array.push_back(top_right)
		point_array.push_back(bottom_right)
		point_array.push_back(bottom_left)
		collision_polygon.polygon = point_array

func _on_Area2D_body_entered(body):
	var parent = body.get_parent()
	if parent is Component:
		emit_signal("on_component_selected", parent)	

func _on_Area2D_body_exited(body):
	var parent = body.get_parent()
	if parent is Component:
		emit_signal("on_component_deselected", parent)

func set_colour_fill(value):
	colour_fill = value
	update()

func set_colour_border(value):
	colour_border = value
	update()
	
