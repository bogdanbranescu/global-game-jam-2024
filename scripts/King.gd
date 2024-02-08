extends AnimatedSprite2D


@export var timer_to_switch_back = 0.65;
var has_reaction = false;


func _process(delta):
	if not has_reaction:
		return;

	timer_to_switch_back -= delta;
	
	if(timer_to_switch_back <= 0):
		play("Neutral");
		timer_to_switch_back = 0.5
		has_reaction = false;


func invoke_reaction(is_happy: bool):
	timer_to_switch_back = 0.4;
	has_reaction = true;
	if(is_happy):
		play("Happy");
	else:
		play("Angry");
		
