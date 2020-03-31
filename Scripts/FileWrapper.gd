extends Node


func get_files(path):
	var gathered_files = {}
	var file_count = 0
	var directory = Directory.new()
	directory.open(path)
	directory.list_dir_begin()
	while true:
		var file = directory.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			gathered_files[file_count] = path + file
			file_count += 1
		
	return gathered_files
