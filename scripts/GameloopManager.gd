extends Node

var jester_stage: Jester_Stage;


# Called when the node enters the scene tree for the first time.
func _ready():
	Start_Game();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;


func Start_Game():

	jester_stage = preload("res://scenes/jester_stage.tscn").instantiate() as Jester_Stage;
	pass;