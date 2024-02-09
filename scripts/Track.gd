extends Node


signal generated_timestamp(ts)
signal jumped

@export var event_name: String
var instance: EventInstance
var is_paused: bool = false

var tempo : int
var beat_duration : float

var beat_timestamp : int = 0
var player_timestamp : int = 0
var movement_diff

var current_timestamp : int = 0
var previous_timestamp : int = 0


func _ready() -> void:
	event_name = self.name
	generated_timestamp.connect(RhythmManager._on_new_timestamp)
	jumped.connect(RhythmManager._on_jump)
	RhythmManager.track_name = event_name

	instance = FMODRuntime.create_instance_path("event:/" + event_name)
	instance.start()
	# DEBUG
	#instance.set_volume(0.0)

	var type = FMODStudioModule.FMOD_STUDIO_EVENT_CALLBACK_SOUND_PLAYED
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


func event_callback(_args) -> void:
	pass
	#print("###" + str(instance.get_timeline_position()))
	

func _physics_process(_delta) -> void:
	previous_timestamp = current_timestamp
	current_timestamp = instance.get_timeline_position()
	generated_timestamp.emit(current_timestamp)

	if abs(previous_timestamp - current_timestamp) > 1000:
		jumped.emit()
		

func _on_instance_stop() -> void:
	if instance.get_playback_state() == FMODStudioModule.FMOD_STUDIO_PLAYBACK_PLAYING:
		instance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
		instance.release()
	else:
		instance.start()


func _on_instance_pause() -> void:
	is_paused = !is_paused
	instance.set_paused(is_paused)


func update_difficulty():
	glb.difficulty = min(glb.difficulty + 1, 4)
	FMODStudioModule.get_studio_system().set_parameter_by_name("Progress1", glb.difficulty, false)
