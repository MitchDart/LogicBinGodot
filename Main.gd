tool

extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_wire()

func set_wire():
	var wire = get_node("Wire")
	wire.start_point = get_node("AndGate").get_output_A_position()
	wire.end_point = get_node("XNorGate").get_input_A_position()
	wire.start_point_direction = get_node("AndGate").rotation_degrees
	wire.end_point_direction = get_node("XNorGate").rotation_degrees

func _on_AndGate_on_drag():
	set_wire()

func _on_XNorGate_on_drag():
	set_wire()
