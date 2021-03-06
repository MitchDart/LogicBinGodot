extends Camera2D

func _ready():
	get_tree().get_root().connect("size_changed", self, "window_resize")
	window_resize()
	
func window_resize():
	var current_size = OS.get_window_size()
	scale = current_size

export var _zoomSensitivity = 0.04
var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;

func _unhandled_input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_MIDDLE:
		if event.is_pressed():
			get_tree().set_input_as_handled()
			_previousPosition = event.position;
			_moveCamera = true;
		else:
			_moveCamera = false;
	elif event is InputEventMouseMotion && _moveCamera:
		get_tree().set_input_as_handled();
		position += (_previousPosition - event.position)*zoom;
		_previousPosition = event.position;
	elif event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_DOWN:
		get_tree().set_input_as_handled();
		zoom += Vector2(_zoomSensitivity*zoom[0], _zoomSensitivity*zoom[0])
	elif event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_UP:
		get_tree().set_input_as_handled();
		zoom -= Vector2(_zoomSensitivity*zoom[0], _zoomSensitivity*zoom[0])
