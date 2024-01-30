extends TextureProgressBar


func _ready():
	pass


func _process(delta):
	self.value = GameloopManager.fun_bar_level;