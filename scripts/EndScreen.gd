extends Node2D

var pressed_restart = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(pressed_restart):
		return;
	
	var pressed_right = Input.is_action_just_pressed("ui_right")
	var pressed_left = Input.is_action_just_pressed("ui_left")
	var pressed_down = Input.is_action_just_pressed("ui_down")
	var pressed_bottom = Input.is_action_just_pressed("ui_up")

	var pressed_arrow = pressed_right or pressed_left or pressed_down or pressed_bottom;

	if(pressed_arrow):
		pressed_restart = true;
		get_tree().reload_current_scene();
		(self as Node2D).free();
	pass
