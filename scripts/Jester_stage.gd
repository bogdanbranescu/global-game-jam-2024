class_name Jester_Stage extends TileMap

var _sizeX = 5;
var _sizeY = 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	create_map(5, 5);

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
				set_cell(0, Vector2i(x, y), 1, Vector2i(0,0));
			invert = !invert;
	
	# EDGES
	for x in sizeX:
		set_cell(0, Vector2(x, sizeX), 0, Vector2i(0,0));
	for y in sizeY:
		set_cell(0, Vector2(-1, y), 2, Vector2i(0,0));

	pass;


func set_entity_on_cell(entity_index: int, cellVector: Vector2i, layer: int):
	set_cell(layer, cellVector, entity_index, Vector2i(0,0))
	# if(obj == null):
	# 	print_debug("ERROR: Setting object on cell is null");

	# var local_pos = map_to_local(cellVector);
	# obj.set_position(local_pos);
	# pass;


func get_position_on_cell(cellVector: Vector2i):
	var localPos = map_to_local(cellVector);
	var offSetpost = position + localPos;
	return offSetpost;

func get_grid_size():
	return Vector2i(_sizeX, _sizeY);

func clamp_cellVector(cellVector: Vector2i):
	var size = get_grid_size();
	var x = clamp(cellVector.x, 0, size.x - 1);
	var y = clamp(cellVector.y, 0, size.y - 1);
	return Vector2i(x, y);

func remove_tile_event_from_cell(cellVector:Vector2i):
	set_cell(1, cellVector, -1, Vector2i(0,0));