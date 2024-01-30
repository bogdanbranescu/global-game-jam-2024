extends Node


@onready var stage_event = load("res://scenes/StageEvent.tscn")

@onready var stage_info = GameloopManager.movementTracker
@onready var stage = get_node(glb.jester_stage_path) as Jester_Stage

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
	spawn_event()


func _on_spawn_event(event_type, grid_location, timestamp):
	var new_stage_event = stage_event.instantiate()
	new_stage_event.event_type = event_type
	new_stage_event.grid_location = grid_location
	new_stage_event.timestamp = timestamp
	get_node(glb.events_path).add_child(new_stage_event)
	new_stage_event.spawn()


func spawn_event():
	var event_location = Vector2i(randi() % 5, randi() % 5)
	var player_location = stage_info.get_current_cell_position()
	while player_location == event_location:
		event_location = Vector2i(randi() % 5, randi() % 5)
	stage.set_entity_on_cell(3, event_location, 1)
	
	return event_location


func pick_location() -> Vector2i:
	var player_position = Vector2.ONE * 2 #
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
	var northmost_cell = from + Vector2i(0, -distance)
	var cells = [northmost_cell]
	var directions = [
		Vector2i(1, 1),			# SE edge
		Vector2i(-1, 1),		# SW edge
		Vector2i(-1, -1),		# NW edge
		Vector2i(-1, -1)		# NE edge
	]

	for d in directions:
		for i in range(distance):
			var new_cell = cells[i-1] + d
			cells.append(new_cell)

	cells = cells.filter(func (x): return x == x.clamp(Vector2i.ZERO, stage.get_grid_size()))

	print(cells)

	for cell_coordinates in cells:
		stage.set_entity_on_cell(3, cell_coordinates, 1)
	
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
