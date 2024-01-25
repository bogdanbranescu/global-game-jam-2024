extends CharacterBody2D


signal moved
signal stop_track
signal pause_track

var direction := Vector2.ZERO
@onready var speed := glb.speed


func handle_input() -> void:
	direction = Vector2.ZERO

	if Input.is_action_just_pressed("ui_right"):
		direction = Vector2i(1, 0)
	elif Input.is_action_just_pressed("ui_left"):
		direction = Vector2i(-1, 0)
	elif Input.is_action_just_pressed("ui_down"):
		direction = Vector2i(0, 1)
	elif Input.is_action_just_pressed("ui_up"):
		direction = Vector2i(0, -1)

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
	position += direction * speed


func _on_grade_received(grade):
	$GradeLabel.text = "[color=%s]%s[/color]" % [{"GOOD": "green", "BAD": "red"}[grade], grade]
	
	$GradeLabel.scale = Vector2.ONE
	create_tween().tween_property($GradeLabel, "scale", Vector2(0.5, 0.5), 0.5)
