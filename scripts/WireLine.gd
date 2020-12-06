extends Line2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	default_color = Color(1, 1, 1, 1)
	texture = preload("res://images/wire.svg")
	width = 32
	texture_mode = Line2D.LINE_TEXTURE_STRETCH
	begin_cap_mode = Line2D.LINE_CAP_BOX
	set_joint_mode(Line2D.LINE_JOINT_BEVEL)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
