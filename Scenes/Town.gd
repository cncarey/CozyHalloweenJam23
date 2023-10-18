extends Node2D

@onready var player : CharacterBody2D = $player
@onready var plants : Node2D = $plants
@onready var tileMap : TileMap = $TileMap

@onready var catPoints : Node2D =  $Cats

@onready var cat = preload("res://Characters/Cat.tscn")
func _ready():
	Game.connect("_ShowPumpkins",_ShowPumpkins)
	Game.connect("_AddBlackCats", _AddBlackCats)
	pass

	
func _ShowPumpkins():
	tileMap.set_layer_enabled(3, true)
	pass

func _AddBlackCats():
	for p in catPoints.get_children():
		var _cat = cat.instantiate()
		_cat.position = p.position
		add_child(_cat)
	pass
