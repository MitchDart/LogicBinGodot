extends MeshInstance2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var mouse_hover = false

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
