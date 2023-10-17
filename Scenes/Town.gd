extends Node2D

@onready var player : CharacterBody2D = $player
@onready var plants : Node2D = $plants

func _ready():
	Game.connect("_ShowPumpkins",_ShowPumpkins)
	pass

	
func _ShowPumpkins():
	#TODO enable the pumpkins tilemap layer
	print("show pumpkins")
	pass
