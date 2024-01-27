extends Node


@onready var stage_event = load("res://scenes/StageEvent.tscn")

enum {
	EVENT_TYPE_BANANA,
	EVENT_TYPE_BIRD,
	EVENT_TYPE_BALLS,
}


func _ready():	
	pass


func _on_spawn_event(event_type, grid_location, timestamp):
	var new_stage_event = stage_event.instantiate()
	new_stage_event.event_type = event_type
	new_stage_event.grid_location = grid_location
	new_stage_event.timestamp = timestamp
	get_node(glb.events_path).add_child(new_stage_event)
	new_stage_event.spawn()
