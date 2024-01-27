extends Node

signal stop_track
signal pause_track

signal wrong_beat

var movementTracker = MovementTracker.new();

var fun_bar_level = 50;
var game_is_active = false;


func _ready():
	movementTracker.load(get_node(glb.jester_stage_path) as Jester_Stage);
	Start_Game();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not game_is_active:
		return;

	if fun_bar_level < 0:
		_handle_lose_game();

	var decrease_ratio = 5;
	fun_bar_level -= decrease_ratio * _delta;



func Start_Game():
	game_is_active = true;
	pass;


func _physics_process(_delta):
	handle_input();


func handle_input() -> void:
	var player = get_node(glb.player_path) as Player;

	var pressed_right = Input.is_action_just_pressed("ui_right")
	var pressed_left = Input.is_action_just_pressed("ui_left")
	var pressed_down = Input.is_action_just_pressed("ui_down")
	var pressed_bottom = Input.is_action_just_pressed("ui_up")

	var pressed_move = pressed_right or pressed_left or pressed_down or pressed_bottom;
	if(pressed_move):
		var new_move = Vector2i.ZERO
		if RhythmManager.can_move:
			if pressed_right:
				new_move = Vector2i(1, 0)

			elif pressed_left:
				new_move = Vector2i(-1, 0)
	
			elif pressed_down:
				new_move = Vector2i(0, 1)
	
			elif pressed_bottom:
				new_move = Vector2i(0, -1)
			
				movementTracker.move(new_move)
			

			_handle_pressed_on_beat();
		else:
			_handle_pressed_off_beat();
	
		if pressed_right:
			player.flip_sprite(false)
		elif pressed_left:
			player.flip_sprite(true)

		player.move(movementTracker.get_current_world_position());


	if Input.is_action_just_pressed("ui_accept"):
		pause_track.emit()

	if Input.is_action_just_pressed("ui_cancel"):
		stop_track.emit()


func _handle_pressed_on_beat():
	print_debug("handling pressed on beat");

	var player = get_node(glb.player_path) as Player;
	player.handle_pressed_on_beat();

	get_node(glb.king_path).invoke_reaction(true);

	pass;
	
	
func _handle_pressed_off_beat():
	print_debug("handling pressed off beat");

	var player = get_node(glb.player_path) as Player;
	player.handle_stutter();

	get_node(glb.king_path).invoke_reaction(false);
	
	pass;


func _handle_lose_game():
	print_debug("handling lose game");

	game_is_active = false;

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
