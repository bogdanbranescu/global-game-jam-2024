extends Node2D


@export var track_name : String
var current_track

var Track = load("res://scenes/Track.tscn") 


func _ready() -> void:
	start_track()
	pass
 

func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		start_track()


	if Input.is_action_just_pressed("ui_accept"):
		glb.difficulty = min(glb.difficulty + 1, 4)
		current_track.update_difficulty()
		print("Difficulty: ", glb.difficulty)


func start_track() -> void:

	RhythmManager.toggle_activity(true);

	current_track = Track.instantiate()
	current_track.name = track_name
	add_child(current_track)

	var worldGameloop = get_node(glb.worldGameloop_path) as WorldGameloop;

	# Connect player actions to the track
	%Player.moved.connect(current_track._on_player_moved)					# PLAYER - GAME
	worldGameloop.pause_track.connect(current_track._on_instance_pause)			# TRACK - GAME
	worldGameloop.stop_track.connect(current_track._on_instance_stop)				# TRACK - GAME
