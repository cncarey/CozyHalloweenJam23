extends Node2D

@onready var player : CharacterBody2D = $player
@onready var plants : Node2D = $plants

var pumpkinPlant = preload("res://Objects/pumpkinPlant.tscn")

func _input(event):
	if event.is_action("interact"):
		var plant = pumpkinPlant.instantiate()
		plant.global_position = player.global_position
		plants.add_child(plant)
