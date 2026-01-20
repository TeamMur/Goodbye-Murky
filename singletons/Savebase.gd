extends Node

var last_unlocked_level: int = 0

var save_path = "res://temp/"
var dot_save = ".txt"

func save_dict(dict, file_name):
	var file = FileAccess.open(save_path + file_name + dot_save, FileAccess.WRITE)
	var json_string = JSON.stringify(dict)
	file.store_string(json_string)

func load_dict(file_name):
	var file = FileAccess.open(save_path + file_name + dot_save, FileAccess.READ)
	var json_string = file.get_as_text()
	return JSON.parse_string(json_string)
