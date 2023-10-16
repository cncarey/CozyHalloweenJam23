extends Node2D

func  _ready():
	pass

func startGame():
	Game.reset()
	get_tree().change_scene_to_file("res://Scenes/Town.tscn")
	pass # Replace with function body.
