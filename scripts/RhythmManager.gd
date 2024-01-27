extends Node


signal can_move_changed
var can_move : bool:
	set(value):
		can_move = value
		can_move_changed.emit()

var track_name : String:
	set(value):
		track_name = value
		generate_movement_windows()

var timestamp : int
var tolerance : int = 100
var timeline_events : Array
var timeline_windows : Array[Array]


func _ready() -> void:
	# TODO connect nodes
	pass


func _physics_process(delta):
	pass


func _on_new_timestamp(timestamp : int) -> void:
	self.timestamp = timestamp


func generate_movement_windows() -> void:
	timeline_events = TrackParser.get_subevents(track_name)
	timeline_windows = []
	
	for t in timeline_events:
		timeline_windows.append([max(0, t - tolerance), t + tolerance])

	print(timeline_events)
	print(timeline_windows)
		