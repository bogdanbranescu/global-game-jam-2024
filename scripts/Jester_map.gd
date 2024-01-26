extends TileMap

var _sizeX = 5;
var _sizeY = 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("Create map");
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;


func create_map(sizeX: int, sizeY: int):
	_sizeX = sizeX;
	_sizeY = sizeY;
	var invert = false;
	for x in sizeX:
		for y in sizeY:
			if invert:
				set_cell(0, Vector2(x, y), 1, Vector2i(0,0));
			else:
				set_cell(0, Vector2i(x, y), 0, Vector2i(0,0));
			invert = !invert;
	
	pass;


func set_obj_on_cell(obj: Node2D, cellVector: Vector2i):
	if(obj == null):
		print_debug("ERROR: Setting object on cell is null");

	var local_pos = map_to_local(cellVector);
	obj.set_position(local_pos);
	pass;


func get_position_on_cell(cellVector: Vector2i):
	return map_to_local(cellVector);