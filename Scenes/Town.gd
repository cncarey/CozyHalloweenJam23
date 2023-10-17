extends Node2D

@onready var player : CharacterBody2D = $player
@onready var plants : Node2D = $plants
@onready var tileMap : TileMap = $TileMap

func _ready():
	Game.connect("_ShowPumpkins",_ShowPumpkins)
	pass

	
func _ShowPumpkins():
	tileMap.set_layer_enabled(3, true)
	pass
