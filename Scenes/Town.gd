extends Node2D

@onready var player : CharacterBody2D = $player
@onready var plants : Node2D = $plants
@onready var tileMap : TileMap = $TileMap

@onready var catPoints : Node2D =  $Cats
@onready var VendingPoints: Node2D = $VendingMachinePoints
@onready var DotDPoints: Marker2D = $DotDBand

@onready var cat = preload("res://Characters/Cat.tscn")
@onready var vending = preload("res://Objects/Shops/VendingMachine.tscn")
@onready var DotDBand = preload("res://Characters/DotDDancers.tscn")
@onready var ui : CanvasLayer = $UI

func _ready():
	Game.connect("_ShowPumpkins",_ShowPumpkins)
	Game.connect("_ShowYourPumpkins",_ShowYourPumpkins)
	Game.connect("_AddBlackCats", _AddBlackCats)
	Game.connect("_AddVendingMachines", _AddVendingMachines)
	Game.connect("_DayOfTheDead", _DayOfTheDead)
	Game.connect("_AddCemetery", _AddCemetery)
	Game.connect("_AddScarecrows", _AddScarecrows)
	Game.connect("_AddPumpkinPatch", _AddPumpkinPatch)
	pass

	
func _ShowPumpkins():
	tileMap.set_layer_enabled(3, true)
	pass
	
func _ShowYourPumpkins():
	tileMap.set_layer_enabled(4, true)
	pass
	
func _AddCemetery():
	tileMap.set_layer_enabled(5, true)
	tileMap.set_layer_enabled(6, true)
	pass
	
func _AddScarecrows():
	tileMap.set_layer_enabled(7, true)
	pass
	
func _AddPumpkinPatch():
	tileMap.set_layer_enabled(8, true)
	tileMap.set_layer_enabled(9, true)
	pass

func _AddBlackCats():
	for p in catPoints.get_children():
		var _cat = cat.instantiate()
		_cat.position = p.position
		add_child(_cat)
	pass
	
func _DayOfTheDead():
	var _dotd = DotDBand.instantiate()
	_dotd.global_position = DotDPoints.global_position
	_dotd.scale = Vector2(.6, .6)
	add_child(_dotd)
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
