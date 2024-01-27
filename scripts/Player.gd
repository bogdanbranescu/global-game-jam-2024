class_name Player extends CharacterBody2D


signal moved
signal stop_track
signal pause_track

var direction := Vector2.ZERO
@onready var speed := glb.speed

var movementTracker = MovementTracker.new();

func _ready():
	movementTracker.load(get_node("/root/World/Level/jester_stage") as Jester_Stage);

func handle_input() -> void:
	direction = Vector2.ZERO

	if Input.is_action_just_pressed("ui_right"):
		movementTracker.move(Vector2i(1, 0));

	elif Input.is_action_just_pressed("ui_left"):
		movementTracker.move(Vector2i(-1, 0));

	elif Input.is_action_just_pressed("ui_down"):
		movementTracker.move(Vector2i(0, 1));
		
	elif Input.is_action_just_pressed("ui_up"):
		movementTracker.move(Vector2i(0, -1));

	if direction != Vector2.ZERO:
		moved.emit()

	if Input.is_action_just_pressed("ui_accept"):
		pause_track.emit()

	if Input.is_action_just_pressed("ui_cancel"):
		stop_track.emit()
	


func _physics_process(_delta):
	handle_input()
	move()


func move() -> void:
	# TODO set_animation("Walk")
	# animation_tree.set("parameters/Idle/blend_position", direction)
	# animation_tree.set("parameters/Walk/blend_position", direction)
	# velocity = direction * speed
	# set_velocity(velocity * 3)
	# move_and_slide()

	position = movementTracker.get_current_world_position();
	pass;



func _on_grade_received(grade):
	$GradeLabel.text = "[color=%s]%s[/color]" % [{"GOOD": "green", "BAD": "red"}[grade], grade]
	
	$GradeLabel.scale = Vector2.ONE
	create_tween().tween_property($GradeLabel, "scale", Vector2(0.6, 0.6), 0.25)


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