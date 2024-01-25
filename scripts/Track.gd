extends Node


signal grade_player(grade)

@export var event_name: String
var instance: EventInstance
var is_paused: bool = false

var tempo : int

var player_timestamp : int = 0
var tolerance : int = 100

var grade : String = "NONE"


func _ready() -> void:
	%Player.moved.connect(self._on_player_moved)
	%Player.pause_track.connect(self._on_instance_pause)
	%Player.stop_track.connect(self._on_instance_stop)
	grade_player.connect(%Player._on_grade_received)

	instance = FMODRuntime.create_instance_path("event:/" + event_name)
	instance.start()
	#instance.release()
	#instance.start_command_capture()

	instance.set_callback(beat_callback, FMODStudioModule.FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_BEAT)
	instance.set_callback(marker_callback, FMODStudioModule.FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_MARKER)


func _on_player_moved() -> void:
	player_timestamp = instance.get_timeline_position()
	grade = compute_grade()
	send_grade()


func beat_callback(args) -> void:
	var beat_timestamp = args.properties.position
	if beat_timestamp == 0:
		tempo = args.properties.tempo

	var movement_diff = beat_timestamp - player_timestamp
	if abs(movement_diff) < tolerance:
		grade = "GOOD"
	else:
		grade = "BAD"
	call_deferred("send_grade")		# indirect due to callback

	print(
		str(args.properties.beat) + "\t" + str(args.properties.position) +
		"\t" + str(player_timestamp) +
		"\t" + str(movement_diff) +
		"\t"  + grade
	)


func marker_callback(args) -> void:
	print("Marker: " + args.properties.name + " at position: " + str(args.properties.position))


func compute_grade() -> String:
	var movement_diff = instance.get_timeline_position() - player_timestamp
	if abs(movement_diff) < tolerance:
		return "GOOD"
	else:
		return "BAD"


func send_grade() -> void:
	grade_player.emit(grade)


func _on_instance_stop() -> void:
	if instance.get_playback_state() == FMODStudioModule.FMOD_STUDIO_PLAYBACK_PLAYING:
		instance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
		instance.release()
	else:
		instance.start()


func _on_instance_pause() -> void:
	is_paused = !is_paused
	instance.set_paused(is_paused)
