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
@onready var beatpad_marker = $TheWall/Beatpad_Marker
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
	initialise_sequence(samples.size(), steps)
	make_sequencer()
	
	for i in range(50):
		var asp = AudioStreamPlayer.new()
		add_child(asp)
		players.push_back(asp)

func print_sequence():
	print()
	for row in range(samples.size() -1, -1, -1):
		var s = ""
		for col in range(steps):
			s += "1" if sequence[row][col] else "0" 
		print(s)
		
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
	

var s = 0.04
var spacer = 1.1

func make_sequencer():	
	
	for col in range(steps):		
		
		for row in range(samples.size()):
			var pad = pad_scene.instantiate()
			
			var p = Vector3(s * col * spacer, s * row * spacer, 0)
			pad.position = p		
			pad.rotation = rotation
			#var tm = TextMesh.new()
			#tm.font = font
			#tm.font_size = 1
			#tm.depth = 0.005
			## tm.text = str(row) + "," + str(col)
			#tm.text = file_names[row]
			#pad.get_node("MeshInstance3D2").mesh = tm
			pad.area_entered.connect(toggle.bind(row, col))
			add_child(pad)
		
func load_samples():
	var dir = DirAccess.open(path_str)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		# From https://forum.godotengine.org/t/loading-an-ogg-or-wav-file-from-res-sfx-in-gdscript/28243/2
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			if file_name.ends_with('.wav.import') or file_name.ends_with('.mp3.import'):			
				file_name = file_name.left(len(file_name) - len('.import'))
				# var asp = AudioStreamPlayer.new()
				# asp.set_stream(load(SOUND_DIR + '/' + filename))
				# add_child(asp)
				# var arr = file_name.split('/')
				# var name = arr[arr.size()-1].split('.')[0]
				# samples[name] = asp
			
				var stream = load(path_str + "/" + file_name)
				stream.resource_name = file_name
				samples.push_back(stream)
				file_names.push_back(file_name)
				# $AudioStreamPlayer.play()
				# break
			file_name = dir.get_next()	

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
	pass
	
func _on_16_pressed():
	scale.x = 1.5
	steps = 16
	steps_designer()
	
func _on_bpm_new_value(value):
	var bpm = remap(value, 0, 180, 60, 480)
	timer.wait_time = 60/bpm

func _on_clear_pressed():
	for i in range(step_balls.size()):
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
