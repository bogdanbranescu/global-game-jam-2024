class_name WorldGameloop extends Node

signal stop_track
signal pause_track

signal wrong_beat

# var event_collecter_tracker = EventCollectTracker.new(); 

var already_moved_on_beat = false;

var movementTracker = MovementTracker.new();

var fun_bar_level = 50;
var game_is_active = false;

var fun_bar_modifiers = {
	"beat_passed_decrement": 1.5,
	"on_beat_increment": 5.5,
	"off_beat_decrement": 3.0,
}


@onready var _eventSpawner: EventSpawner = get_node(glb.eventSpawner_path) as EventSpawner;

func _ready():
	movementTracker.load(get_node(glb.jester_stage_path) as Jester_Stage);
	start_a_countdown();
	pass;

func _handle_decrease_fun_bar():
	fun_bar_level -= fun_bar_modifiers.get("beat_passed_decrement", 0);
	fun_bar_level = clamp(fun_bar_level, 0, 100);

	if fun_bar_level < 0:
		_handle_lose_game();

	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not game_is_active:
		return;

	if fun_bar_level <= 0:
		_handle_lose_game();



var starting_number = 4
var current_number = 4;

func decrement_countdown():
	var label_node = get_node(glb.label_path) as Label

	if current_number <= 0:
		current_number = 0;
	
	current_number -= 1;
	label_node.text = str(current_number);

func start_a_countdown():
	var label_node = get_node(glb.label_path) as Label
	label_node.text = str(starting_number)

	var tween = create_tween()


	# Create a sequence of tweens with delays
	tween.tween_property(label_node, 'scale', Vector2(0, 0), 1).from(Vector2(1, 1)).finished.connect(decrement_countdown)
	tween.tween_property(label_node, 'scale', Vector2(0, 0), 1).from(Vector2(1, 1)).finished.connect(decrement_countdown)
	tween.tween_property(label_node, 'scale', Vector2(0, 0), 1).from(Vector2(1, 1)).finished.connect(decrement_countdown)
	tween.tween_property(label_node, 'scale', Vector2(0, 0), 1).from(Vector2(1, 1)).finished.connect(decrement_countdown)

	tween.finished.connect(Start_Game);
	tween.set_parallel(false)
	

func Start_Game():
	game_is_active = true;

	var player = get_node(glb.player_path) as Player;
	player.move(movementTracker.get_current_world_position());

	RhythmManager.tick_event.connect(_handle_decrease_fun_bar);
	# event_collecter_tracker = EventCollectTracker.new();
	# event_collecter_tracker.create_new_sequence();

	pass;




func _physics_process(_delta):
	if not RhythmManager.can_move:
		already_moved_on_beat = false;


	if game_is_active && not already_moved_on_beat:
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
			already_moved_on_beat = true;
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
		player.set_offset(new_move);


	# if Input.is_action_just_pressed("ui_accept"):
	# 	pause_track.emit()

	# if Input.is_action_just_pressed("ui_cancel"):
	# 	stop_track.emit()


func _handle_pressed_on_beat():
	var player = get_node(glb.player_path) as Player;
	player.handle_pressed_on_beat();

	get_node(glb.king_path).invoke_reaction(true);
	
	if(movementTracker.check_if_standing_on_event()):
		fun_bar_level += fun_bar_modifiers.get("on_beat_increment", 0);

		var jester_stage = get_node(glb.jester_stage_path) as Jester_Stage;
		jester_stage.remove_tile_event_from_cell(movementTracker.get_current_cell_position());

		_eventSpawner.spawn_event();

	pass;
	
	
func _handle_pressed_off_beat():
	var player = get_node(glb.player_path) as Player;
	player.handle_stutter();

	get_node(glb.king_path).invoke_reaction(false);

	fun_bar_level -= fun_bar_modifiers.get("off_beat_decrement", 0);


	pass;


func _handle_lose_game():
	game_is_active = false;

	pause_track.emit();

	var source_wav_lose_audio =preload("res://audio/Cubase/GGJ 2024/TrombFart.wav");
	var lose_audio = AudioStreamPlayer.new();

	lose_audio.finished.connect(
		func():
			var lose_scene = preload("res://scenes/EndScreen.tscn").instantiate();
			get_tree().get_root().add_child(lose_scene);

			RhythmManager.reset();
			
			pass;
			);


	add_child(lose_audio);
	lose_audio.stream = source_wav_lose_audio;
	lose_audio.play();



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
		

	func get_current_cell_position() -> Vector2i:
		return currentCellPosition;


	func get_current_world_position() -> Vector2:
		return _jester_stage.get_position_on_cell(currentCellPosition);

	func check_if_standing_on_event():
		var cell_id = _jester_stage.get_cell_source_id(1, get_current_cell_position());

		var banana_tile_id = 3;
		if cell_id != -1 and cell_id == banana_tile_id:
			return true;
		
		return false;


class EventCollectTracker:
	var next_event_to_collect_index = 0;
	var current_event_sequence = [];

	func create_new_sequence():
		var sequence = [];

		next_event_to_collect_index = 0;

		current_event_sequence = [];

		for event_type in EventSpawner.Event_Type:
			sequence.push_front(event_type);
			sequence.push_front(event_type);
		
		shuffle_array(sequence);

		for i in range(3):
			var event_index = randi() % sequence.size();
			var selected_event = sequence[event_index];
			current_event_sequence.push_front(selected_event);


		# WARNING: This is a quick update because banana is the only event implement from the game design
		# REMOVE THIS WHEN OTHER EVENTS ARE IMPLEMENTED
		current_event_sequence = [
			EventSpawner.Event_Type.EVENT_TYPE_BANANA,
			EventSpawner.Event_Type.EVENT_TYPE_BANANA,
			EventSpawner.Event_Type.EVENT_TYPE_BANANA,
		]



	func shuffle_array(arr):
		var n = arr.size()
		for i in range(n - 1, 0, -1):
			var j = randi() % (i + 1)
			arr[i] = arr[j];
			arr[j] =  arr[i];


	func invoke_collect_event(collected_event: EventSpawner.Event_Type):
		var collected_proper_event = current_event_sequence[next_event_to_collect_index] == collected_event;

		if collected_proper_event:
			next_event_to_collect_index += 1;
			if next_event_to_collect_index >= current_event_sequence.size():
				current_event_sequence = create_new_sequence();
				next_event_to_collect_index = 0;
		else:
			current_event_sequence = create_new_sequence();
			next_event_to_collect_index = 0;
