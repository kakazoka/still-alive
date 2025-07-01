extends Node


const save_location = "user://SaveFile.json"

var contents_to_save: Dictionary = {
	"total_gun_parts": 0
}


func new_game():
	contents_to_save = {
		"total_gun_parts": 0
	}
	save()


func save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()


func save_on_player_death():
	contents_to_save.total_gun_parts  = GlobalVariables.total_gun_parts
	save()


func load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		var save_data = data.duplicate()
		contents_to_save.total_gun_parts = save_data.total_gun_parts
		GlobalVariables.total_gun_parts = contents_to_save.total_gun_parts
