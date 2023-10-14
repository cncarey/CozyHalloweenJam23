extends Node2D

func  _ready():
	Utils.load_game()
	print(Game.Harvests)

func startGame():
	get_tree().change_scene_to_file("res://Scenes/Town.tscn")
	pass # Replace with function body.
