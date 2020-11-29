extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("size_changed", self, "window_resize")
	window_resize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_param("global_transform", get_global_transform())
	material.set_shader_param("zoom", get_parent().zoom[0])
	scale = get_parent().zoom * Vector2(1024,600)


func window_resize():
	var current_size = OS.get_window_size()
	scale = current_size
