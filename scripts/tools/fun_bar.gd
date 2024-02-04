extends TextureProgressBar

var _worldGameloop: WorldGameloop;

func _ready():
	_worldGameloop = get_node(glb.worldGameloop_path);
	pass


func _process(delta):
	self.value = _worldGameloop.fun_bar_level;