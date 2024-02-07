extends Node2D

@export var press_play_label: Label;

# Called when the node enters the scene tree for the first time.
func _ready():
	loop_fade_in_and_fade_out();
	RhythmManager.set_physics_process(false);

	
	pass # Replace with function body.


func loop_fade_in_and_fade_out():
	var tween = create_tween();
	tween.tween_property(press_play_label, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1);
	tween.tween_property(press_play_label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1).finished.connect(loop_fade_in_and_fade_out);


	pass;

func _process(delta):
	var pressed_right = Input.is_action_just_pressed("ui_right")
	var pressed_left = Input.is_action_just_pressed("ui_left")
	var pressed_down = Input.is_action_just_pressed("ui_down")
	var pressed_bottom = Input.is_action_just_pressed("ui_up")

	var pressed_arrow = pressed_right or pressed_left or pressed_down or pressed_bottom;

	if (pressed_arrow):
		var worldScene = preload("res://scenes/World.tscn").instantiate();
		get_tree().root.add_child(worldScene);

		RhythmManager.set_physics_process(true);

		(self as Node2D).free();
		pass;

	pass 
