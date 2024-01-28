extends Node


@onready var stage_event = load("res://scenes/StageEvent.tscn")
@onready var stage_info = GameloopManager.movementTracker

enum Event_Type{
	EVENT_TYPE_BANANA,
	EVENT_TYPE_BIRD,
	EVENT_TYPE_BALLS,
}

var difficulty := 0
var distances = [
	[2, 3],
	[2, 3, 4],
	[3, 4],
	[3, 4, 5],
	[4, 5],
]


func _ready():	
	print(pick_location())


func _on_spawn_event(event_type, grid_location, timestamp):
	var new_stage_event = stage_event.instantiate()
	new_stage_event.event_type = event_type
	new_stage_event.grid_location = grid_location
	new_stage_event.timestamp = timestamp
	get_node(glb.events_path).add_child(new_stage_event)
	new_stage_event.spawn()


func pick_location() -> Vector2i:
	var player_position = stage_info.get_current_cell_position()
	var current_distance = distances[difficulty].pick_random()
	var candidates = get_cells_at_distance(player_position, current_distance)
	
	return candidates.pick_random()


func pick_event_type() -> int:
	var roll = randf()
	var event_type = [
		Event_Type.EVENT_TYPE_BANANA,
		Event_Type.EVENT_TYPE_BIRD,
		Event_Type.EVENT_TYPE_BALLS
	].pick_random()

	return event_type


func get_cells_at_distance(from: Vector2i, distance: int) -> Array:
	var cells = [from]		# start with northmost cell
	var directions = [
		Vector2i(1, 1),			# SE edge
		Vector2i(-1, 1),		# SW edge
		Vector2i(-1, -1),		# NW edge
		Vector2i(-1, -1)		# NE edge
	]

	for d in directions:
		for i in range(distance):
			var new_cell = cells[i-1] + d
			if new_cell:		# TODO check if cell is valid
				cells.append(new_cell)


	print(distance, "\t", cells)
	return cells


func compute_weights(event_sequence: Array) -> Array:
	var weights = []
	for e in [
		Event_Type.EVENT_TYPE_BANANA,
		Event_Type.EVENT_TYPE_BIRD,
		Event_Type.EVENT_TYPE_BALLS
	]:
		pass
	return weights