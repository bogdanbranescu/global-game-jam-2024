extends Node2D


@export var track_name : String
var current_track

var Track = load("res://scenes/Track.tscn") 


func _ready() -> void:
	start_track()

func start_track() -> void:
	current_track = Track.instantiate()
	current_track.name = track_name
	add_child(current_track)

	# Connect player actions to the track
	%Player.moved.connect(current_track._on_player_moved)
	%Player.pause_track.connect(current_track._on_instance_pause)
	%Player.stop_track.connect(current_track._on_instance_stop)
	current_track.grade_player.connect(%Player._on_grade_received)
