extends Sprite2D


var tick_length := 12
var bar_length := 8


func _ready():
	pass


func _physics_process(_delta):
	%Indicator.position.x = int(RhythmManager.timestamp / 500.0 * tick_length) % (bar_length * tick_length)
	for n in $Markers.get_children():
		n.visible = n.name == str(glb.difficulty)
	print(glb.difficulty)