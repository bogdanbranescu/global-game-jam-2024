extends Node

signal stop_track
signal pause_track

var movementTracker = MovementTracker.new();


func _ready():
	movementTracker.load(get_node(glb.jester_stage_path) as Jester_Stage);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass;


func Start_Game():
	pass;


func _physics_process(_delta):
	handle_input();


func handle_input() -> void:
	if Input.is_action_just_pressed("ui_right"):
		movementTracker.move(Vector2i(1, 0));

	elif Input.is_action_just_pressed("ui_left"):
		movementTracker.move(Vector2i(-1, 0));

	elif Input.is_action_just_pressed("ui_down"):
		movementTracker.move(Vector2i(0, 1));
		
	elif Input.is_action_just_pressed("ui_up"):
		movementTracker.move(Vector2i(0, -1));

	if Input.is_action_just_pressed("ui_accept"):
		pause_track.emit()

	if Input.is_action_just_pressed("ui_cancel"):
		stop_track.emit()


class MovementTracker:
	var minCellPos = Vector2i.ZERO;
	var maxCellPos = Vector2i.ZERO;

	var currentCellPosition = Vector2i.ZERO;
	var _jester_stage: Jester_Stage;

	func load(jester_stage: Jester_Stage):
		maxCellPos = jester_stage.get_grid_size();
		minCellPos = Vector2i.ZERO;
		_jester_stage = jester_stage;

	func move(direction: Vector2i):
		currentCellPosition += direction;
		currentCellPosition = _jester_stage.clamp_cellVector(currentCellPosition);
		

	func get_current_world_position() -> Vector2:
		return _jester_stage.get_position_on_cell(currentCellPosition);