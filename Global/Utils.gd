extends Node


const SAVE_PATH: String = "user://savegame.bin"
const SAVE_PASS: String = "password"

#const notify = preload("res://Global/Notification.tscn")


#func notif(text):
#	if get_child_count() == 0:
#		var notif1 = notify.instance()
#		notif1.get_node("Label").text = str(text)
#		add_child(notif1)
#		await get_tree().create_timer(3).timeout
#		notif1.queue_free()

func save_game():
	var save_game: FileAccess = FileAccess.open(SAVE_PATH,FileAccess.WRITE_READ)
	var data: Dictionary = {
		"Plot": Game.Plot,
		"Harvests": Game.Harvests,
		"CurrentDay": Game.currentDay
		
	}
	var json_string = JSON.stringify(data)
	save_game.store_line(json_string)
	save_game.close()
	
func load_game():
#	var save_game: FileAccess = get_file()
#	if not save_game:
#		return
#	while not save_game.eof_reached():
#		var current_line = parse_json(save_game.get_line())
#		if current_line:
#			Game.Plot = current_line["Plot"]
#			Game.Harvests = current_line["Harvests"]
#
#	save_game.close()
	
	#TODO if exists
	var save_game = FileAccess.open(SAVE_PATH, FileAccess.WRITE_READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			Game.set(i, node_data[i])
			
	save_game.flush()
