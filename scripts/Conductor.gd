extends Node2D


@onready var note = load("res://scenes/Note.tscn")

@onready var timer = $TickTimer
@onready var sfx_player = $TickSfxPlayer


var bpm = 120
var prev_beat = Time.get_ticks_msec()
var tick_duration = 60.0 / glb.bpm

var momentum = 0


func _ready():
	timer.set_wait_time(tick_duration)
	timer.set_one_shot(false)
	timer.timeout.connect(tick)
	timer.start()


func tick():
	sfx_player.play()
	prev_beat = Time.get_ticks_msec()

	randomize()
	#generate_note(randi() % 3)


func generate_note(line):
	var new_note = note.instantiate()
	new_note.line = line


func _process(delta):
	momentum = clamp(momentum - glb.depletion_rate * delta, 0, 100)


func _on_Player_moved(move_timestamp):
	var beat_difference = move_timestamp - prev_beat

	var earliest_upcoming_allowed = prev_beat + (1 - glb.beat_tolerance) * tick_duration * 1000
	var latest_allowed = prev_beat + glb.beat_tolerance * tick_duration * 1000

	print(latest_allowed, "\t", move_timestamp, "\t", earliest_upcoming_allowed)

	if move_timestamp < latest_allowed or move_timestamp > earliest_upcoming_allowed:
		print(beat_difference)
		momentum += 10
	else:
		momentum -= 2
