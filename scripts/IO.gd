extends MeshInstance2D

signal on_click(io)
signal on_hover(io)

export var is_output = false
export var index = 0

var mouse_hover = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if mouse_hover && event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
		emit_signal("on_click", self)
		get_tree().set_input_as_handled()
				
func _on_Area2D_mouse_entered():
	var tween = get_node("Tween")
	if(tween.is_active()):
		tween.set_active(false)
		scale = Vector2(1.3,1.3)
	else:
		tween.reset_all()
		tween.interpolate_property(self , "scale", Vector2(1.0,1.0), Vector2(1.3,1.3), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		tween.start()
	mouse_hover = true
	emit_signal("on_hover", self, false)


func _on_Area2D_mouse_exited():
	var tween = get_node("Tween")
	if(tween.is_active()):
		tween.set_active(false)
		scale = Vector2(1.0,1.0)
	else:
		tween.reset_all()
		tween.interpolate_property(self , "scale", Vector2(1.3,1.3), Vector2(1.0,1.0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
	mouse_hover = false
	emit_signal("on_hover", self, true)
