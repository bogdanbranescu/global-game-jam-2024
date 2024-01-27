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
	var pressed_right = Input.is_action_just_pressed("ui_right")
	var pressed_left = Input.is_action_just_pressed("ui_left")
	var pressed_down = Input.is_action_just_pressed("ui_down")
	var pressed_bottom = Input.is_action_just_pressed("ui_up")

	var pressed_move = pressed_right or pressed_left or pressed_down or pressed_bottom;
	if(pressed_move):
		print("move");
		if RhythmManager.can_move:
			if pressed_right:
				movementTracker.move(Vector2i(1, 0));
	
			elif pressed_left:
				movementTracker.move(Vector2i(-1, 0));
	
			elif pressed_down:
				movementTracker.move(Vector2i(0, 1));
	
			elif pressed_bottom:
				movementTracker.move(Vector2i(0, -1));
	
			_handle_pressed_on_beat();
		else:
			_handle_pressed_off_beat();

		

	if Input.is_action_just_pressed("ui_accept"):
		pause_track.emit()

	if Input.is_action_just_pressed("ui_cancel"):
		stop_track.emit()


func _handle_pressed_on_beat():
	print_debug("handling pressed on beat");

	var player = get_node(glb.player_path) as Player;
	player.handle_pressed_on_beat();

	pass;
	
	
func _handle_pressed_off_beat():
	print_debug("handling pressed off beat");

	var player = get_node(glb.player_path) as Player;
	player.handle_stutter();
	
	pass;



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
