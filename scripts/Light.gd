extends Component

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
		get_node("GlowMesh").visible = true
		get_node("OffMesh").visible = false
	else:
		get_node("GlowMesh").visible = false
		get_node("OffMesh").visible = true
