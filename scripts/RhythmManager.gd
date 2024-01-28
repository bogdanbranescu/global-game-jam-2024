extends Node


signal spawn_event
signal can_move_changed
signal tick_event

var can_move : bool:
	set(value):
		can_move = value
		can_move_changed.emit()

var track_name : String:
	set(value):
		track_name = value
		generate_movement_windows()

var timeline_events : Array
var eid : int = 0

var timeline_windows : Array[Array]
var wid : int = 0

var timestamp : int
var tolerance : int = 150


func _ready() -> void:
	#spawn_event.connect(EventSpawner._on_spawn_event)
	pass

func _physics_process(_delta) -> void:
	check_movement()
	check_spawn()


func check_movement():
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


func check_spawn():
	if timestamp >= timeline_events[eid]:
		spawn_event.emit(randi() % 3, Vector2(randi() % 5, randi() % 5), timeline_events[eid])
		tick_event.emit()
		eid += 1
		if eid > timeline_events.size() - 1:
			eid = -1


func generate_movement_windows() -> void:
	timeline_events = TrackParser.get_subevents(track_name)
	timeline_windows = []
	
	for t in timeline_events:
		timeline_windows.append([max(0, t - tolerance), t + tolerance])
	

func _on_new_timestamp(tstamp : int) -> void:
	timestamp = tstamp


func _on_jump():
	print("AAAAAAAAAAAA");
	for i in range(timeline_events.size()):
		if timestamp > timeline_events[i]:
			print("timestamp", timestamp);
			print("timeline_events", timeline_events[i]);
			print("-------");
			eid = i
			wid = eid
			break