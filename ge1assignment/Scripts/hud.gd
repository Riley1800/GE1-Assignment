extends CanvasLayer

@onready var Up = $Up  # Reference to the "Up" button
@onready var Left = $Left  # Reference to the "Left" button
@onready var Right = $Right  # Reference to the "Right" button
@onready var Down = $Down  # Reference to the "Down" button
@onready var Interact = $Interact  # Reference to the "Interact" button

@onready var player = get_node("/music_project/player")  # Correct reference to the Player node (assuming it's at the root)
var movement_speed = 5.0  # Movement speed for the player
var moving_forward = false  # Flag for forward movement
var moving_left = false  # Flag for left movement
var moving_right = false  # Flag for right movement
var moving_down = false  # Flag for down movement

func _ready():
	# Connect button signals to respective functions
	Up.pressed.connect(_on_up_pressed)
	Up.released.connect(_on_up_released)

	Left.pressed.connect(_on_left_pressed)
	Left.released.connect(_on_left_released)

	Right.pressed.connect(_on_right_pressed)
	Right.released.connect(_on_right_released)

	Down.pressed.connect(_on_down_pressed)
	Down.released.connect(_on_down_released)

	Interact.pressed.connect(_on_interact_pressed)
	Interact.released.connect(_on_interact_released)

# Function to handle the up movement when the Up button is pressed
func _on_up_pressed() -> void:
	moving_forward = true  # Start moving forward
	print("Moving forward")

# Function to stop the up movement when the Up button is released
func _on_up_released() -> void:
	moving_forward = false  # Stop moving forward
	print("Stopped moving forward")

# Function to handle left movement when the Left button is pressed
func _on_left_pressed() -> void:
	moving_left = true  # Start moving left
	print("Moving left")

# Function to stop the left movement when the Left button is released
func _on_left_released() -> void:
	moving_left = false  # Stop moving left
	print("Stopped moving left")

# Function to handle right movement when the Right button is pressed
func _on_right_pressed() -> void:
	moving_right = true  # Start moving right
	print("Moving right")

# Function to stop the right movement when the Right button is released
func _on_right_released() -> void:
	moving_right = false  # Stop moving right
	print("Stopped moving right")

# Function to handle down movement when the Down button is pressed
func _on_down_pressed() -> void:
	moving_down = true  # Start moving down (if you want downward movement)
	print("Moving down")

# Function to stop the down movement when the Down button is released
func _on_down_released() -> void:
	moving_down = false  # Stop moving down
	print("Stopped moving down")

# Function to handle interaction when the Interact button is pressed
func _on_interact_pressed() -> void:
	print("Interacting with object")

# Function to stop interaction (if needed) when the Interact button is released
func _on_interact_released() -> void:
	print("Stopped interacting")

# Optional: Use _process to apply movement based on button states
func _process(delta):
	var direction = Vector3.ZERO  # Start with no movement

	if moving_forward:
		direction -= player.transform.basis.z  # Move forward along z-axis
	if moving_left:
		direction -= player.transform.basis.x  # Move left along x-axis
	if moving_right:
		direction += player.transform.basis.x  # Move right along x-axis
	if moving_down:
		direction += player.transform.basis.y  # Move down along y-axis (if applicable)

	if direction != Vector3.ZERO:
		player.move_and_slide(direction.normalized() * movement_speed)
