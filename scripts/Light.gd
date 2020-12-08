extends Component

var on_texture = preload("res://images/light/on.svg")
var off_texture = preload("res://images/light/off.svg")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	if inputs.size() == 1:
		if on != inputs[0].on:
			on = inputs[0].on
			update_state_texture()

func update_state_texture():
	if on:
		get_node("BaseMesh").texture = on_texture
		get_node("GlowMesh").visible = true
	else:
		get_node("BaseMesh").texture = off_texture
		get_node("GlowMesh").visible = false
