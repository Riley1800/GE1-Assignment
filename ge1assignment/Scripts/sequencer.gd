extends Marker3D

var samples:Array
var players:Array
var s = 0.04
var spacer = 1.1

@export var font:Font
@export var path_str = "res://samples/"
@export var pad_scene:PackedScene = preload("res://Scripts/Button/ButtonVariation.tscn")
@export var steps = 8
@onready var timer = $Timer
@onready var timer_ball = $timer_ball
@onready var steps_marker = $TheWall/steps_marker
@onready var Instruments_marker = $TheWall/Instruments_marker
@onready var TheWall = $TheWall

var sequence = []
var file_names = []

var asp_index = 0
var step:int = 0
var last_instrument = null
var instrument_steps = []
var pads = []
var step_segments = []
var Reverb: bool = false
var Phaser: bool = false

var rows:int
var cols:int
"""
func initialise_sequence(rows, cols):
	for i in range(rows):
		var row = []
		for j in range(cols):
			row.append(false)
		sequence.append(row)
	self.rows = rows
	self.cols = cols
"""
func _ready():
	load_samples()
	print(file_names)
	#initialise_sequence(samples.size(), steps)
	Instrument_line()
	steps_designer()
	init_steps()
	
	for i in range(50):
		var asp = AudioStreamPlayer.new()
		add_child(asp)
		players.push_back(asp)

func _on_start_stop_area_entered(_area: Area3D) -> void:
	if timer.is_stopped():
		timer.start()
		timer_ball.visible = true
	else:
		timer.stop()

"""
func print_sequence():
	print()
	for row in range(samples.size() -1, -1, -1):
		var s = ""
		for col in range(steps):
			s += "1" if sequence[row][col] else "0" 
		print(s)
"""		
func play_sample(e, i):
	
	print("play sample:" + str(i))
	var p:AudioStream = samples[i]
	var asp = players[asp_index]
	asp.stream = p
	asp.play()
	asp_index = (asp_index + 1) % players.size()

func toggle(e, row, col):
	print("toggle " + str(row) + " " + str(col))
	sequence[row][col] = ! sequence[row][col]
	play_sample(0, row)
		
func load_samples():
	var loc = DirAccess.open(path_str)
	var dir_names = loc.get_directories()
	for i in range(dir_names.size()):
		var dir = DirAccess.open(path_str + dir_names[i])
		var files = dir.get_files()
		for file in range(files.size()):
			if files[file].ends_with('.import'):
				var stream: AudioStream = load(path_str + dir_names[i] + '/' + files[file].trim_suffix('.import'))
				stream.resource_name = files[file]
				file_names.push_back(files[file].trim_suffix('.import'))
				samples.push_back(stream)

func play_step(col):
	var p = Vector3(s * col * spacer, s * -1 * spacer, 0)
			
	$timer_ball.position = p
	for row in range(rows):
		if sequence[row][col]:
			play_sample(0, row)


func _on_timer_timeout() -> void:
	print("step " + str(step))
	play_step(step)
	step = (step + 1) % steps
	pass 
	
func steps_designer():
	var margin = 0.1

	if !step_segments.is_empty():
		for segment in step_segments:
			segment.queue_free()  # Remove old step buttons
		step_segments.clear()

	# Create new step buttons
	for step in range(steps):
		var button = pad_scene.instantiate()  # Instantiate a 3D button
		var x_pos = step * margin  # Position based on step index
		var y_pos = 0  # All steps on the same Y-plane
		var z_pos = 0  # All steps on the same Z-plane
		button.transform.origin = Vector3(x_pos, y_pos, z_pos)

		button.text = "Step: " + str(step + 1)  # Set button label
		
		button.connect("pressed", Callable(self, "toggle_step").bind(step))

		add_child(button) 
		step_segments.push_back(button)  


func Instrument_line():
	var margin = 0.1  # Spacing between buttons in 3D
	var row_size = steps  # Number of buttons per row
	
	for instrument in range(samples.size()):
		var button = pad_scene.instantiate()  
		var x_pos = (instrument % row_size) * margin
		var y_pos = -(instrument / row_size) * margin
		var z_pos = 0  # Keep all buttons on the same Z-plane
		button.transform.origin = Vector3(x_pos, y_pos, z_pos)  # Position buttons in a grid
		
		# Configure the button
		button.text = file_names[instrument].left(10) 
		
		# Correct connection with Callable
		button.connect("pressed", Callable(self, "toggle_pad").bind(instrument)) 
		
		add_child(button) 
		pads.push_back(button)  


func init_steps():
	for i in range(samples.size()):
		var new_instrument = []
		instrument_steps.push_back(new_instrument)
		for step in range(steps):
			instrument_steps[i].push_back(false)
			
func toggle_pad(e, instrument):
	if last_instrument != null:
		pads[last_instrument].manual_toggle()
	steps_designer()
	find_steps(instrument)
	play_sample(0, instrument)
	last_instrument = instrument

			
func find_steps(instrument):
	for i in range(steps):
		if instrument_steps[instrument][i]:
			step_segments[i].manual_toggle()

func StepsSaveState(instrument):
	for i in range (steps):
		if last_instrument != null:
				instrument_steps[instrument][i] = step_segments[i].toggle

func _on_16_pressed():
	scale.x = 2.0
	steps = 16
	steps_designer()
	
func _on_bpm_new_value(value):
	var bpm = remap(value, 0, 180, 60, 480)
	timer.wait_time = 60/bpm

func clear():
	for i in range(instrument_steps.size()):
		for j in range(steps):
			instrument_steps[i][j] = false

func _on_clear_pressed():
	for i in range(step_segments.size()):
		if step_segments[i].toggle:
			step_segments[i].manual_toggle()
	clear()
	
func _on_reverb_pressed():
	Reverb =! Reverb
	AudioServer.set_bus_effect_enabled(0, 2, Reverb)

func _on_phaser_pressed():
	Phaser =! Phaser
	AudioServer.set_bus_effect_enabled(0, 3, Phaser)

func _on_8_pressed():
	scale.x = 1.0
	steps = 8
	steps_designer()
