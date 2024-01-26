extends Node


signal grade_player(grade)

@export var event_name: String
var instance: EventInstance
var is_paused: bool = false

var tempo : int
var beat_duration : float

var beat_timestamp : int = 0
var player_timestamp : int = 0
var tolerance : int = 80	# should be less than (beat_duration / 2)
							# this should be offset after a latency test
var movement_diff

var grade : String = "NONE"	


func _ready() -> void:
	event_name = self.name

	instance = FMODRuntime.create_instance_path("event:/" + event_name)
	instance.start()
	# DEBUG
	instance.set_volume(0.0)

	var type = FMODStudioModule.FMOD_STUDIO_EVENT_CALLBACK_SOUND_PLAYED | FMODStudioModule.FMOD_STUDIO_EVENT_CALLBACK_SOUND_STOPPED
	# FMOD_STUDIO_EVENT_CALLBACK_CREATED					1
	# FMOD_STUDIO_EVENT_CALLBACK_DESTROYED					2
	# FMOD_STUDIO_EVENT_CALLBACK_STARTING					4
	# FMOD_STUDIO_EVENT_CALLBACK_STARTED					8
	# FMOD_STUDIO_EVENT_CALLBACK_RESTARTED					16
	# FMOD_STUDIO_EVENT_CALLBACK_SOUND_PLAYED				8192
	# FMOD_STUDIO_EVENT_CALLBACK_SOUND_STOPPED				16384

	instance.set_callback(event_callback, type)


func _on_player_moved() -> void:
	player_timestamp = instance.get_timeline_position()
	compute_grade()
	send_grade(grade)


func event_callback(args) -> void:
	pass


func check_nothing_pressed() -> void:
	# grade player for not acting at all after the window of tolerance
	create_tween().tween_callback(
		func(): 
			if grade == "NONE": 
				call_deferred("send_grade", "BAD")
				print("# LATE")
			grade = "NONE"
	).set_delay(tolerance / 1000.0)
	

func compute_grade() -> void:
	var movement_diff_early = beat_timestamp + beat_duration - player_timestamp
	var movement_diff_late = player_timestamp - beat_timestamp 
	
	if movement_diff_early < tolerance:
		movement_diff = -movement_diff_early
		grade = "GOOD"
	elif movement_diff_late < tolerance:
		movement_diff = movement_diff_late
		grade = "GOOD"
	else:
		movement_diff = "###"
		grade = "BAD"

	if grade == "GOOD":
		print(movement_diff, " GOOD")
	else:
		print("# EARLY")


func send_grade(new_grade) -> void:
	grade_player.emit(new_grade)


func _on_instance_stop() -> void:
	if instance.get_playback_state() == FMODStudioModule.FMOD_STUDIO_PLAYBACK_PLAYING:
		instance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
		instance.release()
	else:
		instance.start()


func _on_instance_pause() -> void:
	is_paused = !is_paused
	instance.set_paused(is_paused)
