extends Node2D

@onready var player : CharacterBody2D = $player
@onready var plants : Node2D = $plants
@onready var tileMap : TileMap = $TileMap

@onready var catPoints : Node2D =  $Cats
@onready var VendingPoints: Node2D = $VendingMachinePoints

@onready var cat = preload("res://Characters/Cat.tscn")
@onready var vending = preload("res://Objects/Shops/VendingMachine.tscn")
@onready var ui : CanvasLayer = $UI

func _ready():
	Game.connect("_ShowPumpkins",_ShowPumpkins)
	Game.connect("_AddBlackCats", _AddBlackCats)
	Game.connect("_AddVendingMachines", _AddVendingMachines)
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

func _AddVendingMachines():
	var indx = Game.ActiveUpgrades[Game.ADD_VENDING_MACHINES] - 1
	var point = VendingPoints.get_child(indx)
	var _vending = vending.instantiate()
	_vending.position = point.position
	add_child(_vending)
	_vending.connect("OpenPopUp", _on_vending_machine_open_pop_up)
	pass


func _on_vending_machine_open_pop_up(popup):
	ui.add_child(popup)
	pass # Replace with function body.
