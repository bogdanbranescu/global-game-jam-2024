class_name Player extends CharacterBody2D


signal moved
# signal stop_track
# signal pause_track

# var direction := Vector2.ZERO
@onready var speed := glb.speed

func _ready():
	pass;

var previous_pos = Vector2.ZERO;


func move(new_pos: Vector2) -> void:
	# TODO set_animation("Walk")
	# animation_tree.set("parameters/Idle/blend_position", direction)
	# animation_tree.set("parameters/Walk/blend_position", direction)
	# velocity = direction * speed
	# set_velocity(velocity * 3)
	# move_and_slide()

	position = new_pos;

	previous_pos = new_pos;
	pass;


func flip_sprite(should_flip : bool) -> void:
	$AnimatedSprite.flip_h = should_flip;

	pass;



func _on_grade_received(grade):
	$GradeLabel.text = "[color=%s]%s[/color]" % [{"GOOD": "green", "BAD": "red"}[grade], grade]
	
	$GradeLabel.scale = Vector2.ONE
	create_tween().tween_property($GradeLabel, "scale", Vector2(0.6, 0.6), 0.25)


func handle_pressed_on_beat():
	$AnimatedSprite.animation = "Walk"
	$AnimatedSprite.offset.x = -24
	create_tween().tween_property($AnimatedSprite, "offset", Vector2.ZERO, 0.15)


func handle_stutter():
	$AnimatedSprite.animation = "Stutter"


func _on_animated_sprite_animation_looped():
	$AnimatedSprite.animation = "Idle"
