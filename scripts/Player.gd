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
	position = new_pos;
	previous_pos = new_pos;
	pass;


func flip_sprite(should_flip : bool) -> void:
	$AnimatedSprite.flip_h = should_flip;
	pass;


func set_offset(latest_move: Vector2i) -> void:
	$AnimatedSprite.offset = -24 * latest_move;


func handle_pressed_on_beat():	
	$AnimatedSprite.animation = "Walk"
	$AnimatedSprite.offset.x = -24
	create_tween().tween_property($AnimatedSprite, "offset", Vector2.ZERO, 0.1)


func handle_stutter():
	$AnimatedSprite.animation = "Stutter"


func _on_animated_sprite_animation_looped():
	$AnimatedSprite.animation = "Idle"
