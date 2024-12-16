extends Marker3D

var samples:Array
var players:Array

@export var font:Font
@export var path_str = "res://samples/"
@export var pad_scene:PackedScene
@export var steps = 8
@onready var timer = $Timer
@onready var timer_ball = $timer_ball
@onready var steps_marker = $TheWall/Steps_Marker
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
	print_sequence()
		
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
	pass # Replace with function body.


func _on_start_stop_area_entered(area: Area3D) -> void:
	if $Timer.is_stopped():
		$Timer.start()
	else:
		$Timer.stop()
	pass # Replace with function body.
	
func steps_designer():
	var margin = .004
	if !step_segments.is_empty():
		for i in range(step_segments.size()):
			step_segments[i].queue_free()
		step_segments.clear()
	for step in range(steps):
		var step_segments = pad_scene.instantiate()
		var sb_pos = steps_marker.position + Vector3((step_segments.get_child(1).mesh.size.x + margin) * step , 0, 0)
		step_segments.position = sb_pos
		step_segments.rotation = rotation
		step_segments.get_child(3).set_text("Step: " + str(step + 1))
		add_child(step_segments)
		step_segments.push_back(step_segments)
	
func _on_16_pressed():
	scale.x = 1.5
	steps = 16
	steps_designer()
	
func _on_bpm_new_value(value):
	var bpm = remap(value, 0, 180, 60, 480)
	timer.wait_time = 60/bpm

func _on_clear_pressed():
	for i in range(step_segments.size()):
		if step_balls[i].toggle:
			step_balls[i].manual_toggle()
	clear()
	
func _on_reverb_pressed():
	rev_toggle =! rev_toggle
	AudioServer.set_bus_effect_enabled(0, 2, rev_toggle)

func _on_12_pressed():
	scale.x = 1.0
	steps = 12
	steps_designer()
