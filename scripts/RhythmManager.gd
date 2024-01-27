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

var timeline_events : Array
var timeline_windows : Array[Array]

var timestamp : int
var wid : int = 0
var tolerance : int = 100


func _ready() -> void:
	# TODO connect nodes
	pass


func _physics_process(delta) -> void:
	if wid == -1:
		return

	if timestamp > timeline_windows[wid][0] and timestamp < timeline_windows[wid][1]:
		can_move = true
		return
	elif timestamp > timeline_windows[wid][1]:
		wid += 1
		if wid > timeline_windows.size() - 1:
			wid = -1
	
	can_move = false


func _on_new_timestamp(tstamp : int) -> void:
	timestamp = tstamp
	print("%d\t%d" % [Time.get_ticks_msec(), timestamp])


func generate_movement_windows() -> void:
	timeline_events = TrackParser.get_subevents(track_name)
	timeline_windows = []
	
	for t in timeline_events:
		timeline_windows.append([max(0, t - tolerance), t + tolerance])
