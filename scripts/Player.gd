class_name Player extends CharacterBody2D


signal moved
# signal stop_track
# signal pause_track

# var direction := Vector2.ZERO
@onready var speed := glb.speed


func _ready():
	pass;


func _physics_process(_delta):
	# handle_input()
	move()


func move() -> void:
	# TODO set_animation("Walk")
	# animation_tree.set("parameters/Idle/blend_position", direction)
	# animation_tree.set("parameters/Walk/blend_position", direction)
	# velocity = direction * speed
	# set_velocity(velocity * 3)
	# move_and_slide()

	position = GameloopManager.movementTracker.get_current_world_position();
	pass;


func _on_grade_received(grade):
	$GradeLabel.text = "[color=%s]%s[/color]" % [{"GOOD": "green", "BAD": "red"}[grade], grade]
	
	$GradeLabel.scale = Vector2.ONE
	create_tween().tween_property($GradeLabel, "scale", Vector2(0.6, 0.6), 0.25)

