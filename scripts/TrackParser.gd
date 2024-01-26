extends Node


const EVENT_DIR_PATH = "res://audio/fmod/test/Metadata/Event/"


func _ready() -> void:
    var timeline = parse_timeline()
    print(timeline)


func parse_timeline() -> Array:
    var event_file_name = find_event_file("test")
    XML.parse_file(EVENT_DIR_PATH + "")
    return []


func find_event_file(event_name):
    for file in DirAccess.get_files_at(EVENT_DIR_PATH):
        if file.find(event_name) != -1:
            return file