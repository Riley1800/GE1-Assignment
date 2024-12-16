extends Node3D

@export var score: int = 0
@export var speed: float = 10
@export var rot_speed: float = 100
@export var can_move: bool = true

var controlling: bool = true
var relative: Vector2 = Vector2.ZERO

# Allows ESC to bring the mouse back to screen
func _input(event):
	if event is InputEventMouseMotion and controlling:
		relative = event.relative
	if event.is_action_pressed("ui_cancel"):
		if controlling:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Mouse becomes visible
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)   # Mouse becomes hidden
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture mouse
		controlling = !controlling  # Toggle controlling flag

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Initially capture the mouse

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rotation based on axis input (joystick or keyboard)
	var yaw = Input.get_axis("look_right", "look_left")  # Left/Right rotation (look_left, look_right)
	var pitch = Input.get_axis("look_up", "look_down")  # Up/Down rotation (look_up, look_down)

	# Apply the rotation to the player
	if yaw != 0:
		rotate(Vector3.UP, deg_to_rad(yaw * rot_speed * delta))  
	if pitch != 0:
		rotate(transform.basis.x, deg_to_rad(-pitch * rot_speed * delta)) 

	# Player movement based on input
	if can_move:
		var v = Vector3.ZERO
		var mult = 1

		# Sprint when shift is pressed
		if Input.is_key_pressed(KEY_SHIFT):
			mult = 3

		# Left/Right movement 
		var turn = Input.get_axis("move_left", "move_right")
		if abs(turn) > 0:
			position += global_transform.basis.x * speed * turn * mult * delta

		# Forward/Backward movement
		var movef = Input.get_axis("move_forward", "move_back")
		if abs(movef) > 0:
			global_translate(global_transform.basis.z * speed * movef * mult * delta)
