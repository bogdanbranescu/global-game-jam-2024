extends Node2D


var event_type : int
var grid_location : Vector2
var timestamp : int


func _ready():
    pass


func spawn():
    print(str(timestamp) + "\tSpawned event at " + str(grid_location) + " of type " + str(event_type))