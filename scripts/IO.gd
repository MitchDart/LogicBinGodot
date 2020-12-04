extends Node2D

signal on_click(io)
signal on_hover(io)

export var is_output = false
export var index = 0
export var enabled = true setget set_enabled

var mouse_hover = false

func set_enabled(value):
	if enabled != value:
		enabled = value
		get_node("Area2D").input_pickable = enabled
		if !enabled: 
			_on_Area2D_mouse_exited()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if mouse_hover && event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		emit_signal("on_click", self)
		get_tree().set_input_as_handled()
				
func _on_Area2D_mouse_entered():
	var tween = get_node("Mesh/Tween")
	tween.interpolate_property(get_node("Mesh") , "scale", Vector2(1.0,1.0), Vector2(1.3,1.3), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	mouse_hover = true
	emit_signal("on_hover", self, false)


func _on_Area2D_mouse_exited():
	if mouse_hover:
		var tween = get_node("Mesh/Tween")
		tween.stop_all()
		get_node("Mesh").scale = Vector2(1.0,1.0)
		mouse_hover = false
		emit_signal("on_hover", self, true)
