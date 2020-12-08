extends Component

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var on = false

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.is_pressed():
		if on:
			get_node("AnimatedSprite").play("off")
		else:
			get_node("AnimatedSprite").play("on")
		on = !on
		get_tree().set_input_as_handled()
