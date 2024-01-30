extends Node2D

@export var animated_sprites: Array[AnimatedSprite2D] = []


func _ready():
	pass;


func add_sprites(eventTypes: Array[EventSpawner.Event_Type]):
	var anim_names = eventTypes.map(func(value: EventSpawner.Event_Type):
		match value:
			EventSpawner.Event_Type.EVENT_TYPE_BALLS:
				return "Balls"
			EventSpawner.Event_Type.EVENT_TYPE_BIRD:
				return "Bird";
			EventSpawner.Event_Type.EVENT_TYPE_BANANA:
				return "Banana";
	);

	for i in range(anim_names.size()):
		var selected_animation = animated_sprites[i];
		selected_animation.play(anim_names[i]);
	
	pass;
