extends Node


const EVENT_DIR_PATH = "res://audio/fmod/test/Metadata/Event/"
var subevent_type = "SingleSound"

var offset := 0

func get_subevents(event_name) -> Array:
	return parse_timeline(event_name)


func parse_timeline(event_name) -> Array:
	var timeline = []
	var file_path = find_event_file(event_name)

	var flag_next_float = false

	var parser = XMLParser.new()
	parser.open(file_path)
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var attributes_dict = {}
			for idx in range(parser.get_attribute_count()):
				attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)

				if attributes_dict.has("class") and attributes_dict["class"] == subevent_type:
					flag_next_float = true

		elif parser.get_node_type() == XMLParser.NODE_TEXT and parser.get_node_data().is_valid_float() and flag_next_float:
			var new_value = floor(parser.get_node_data().to_float() * 1000 + offset)
			if new_value not in timeline:
				timeline.append(new_value)
			flag_next_float = false

	timeline.sort()
	timeline = timeline.slice(5)

	return timeline


func find_event_file(event_name) -> Variant:
	for file_name in DirAccess.get_files_at(EVENT_DIR_PATH):
		var file_path = EVENT_DIR_PATH + file_name
		var file = FileAccess.open(file_path, FileAccess.READ)
		
		if file:
			var text_content = FileAccess.get_file_as_string(file_path)
			if event_name in text_content:
				file.close()
				return file_path
			file.close()

	return null
