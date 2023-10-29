extends Node2D

@export var speachSound : AudioStream

@onready var player : CharacterBody2D = $player
@onready var plants : Node2D = $plants
@onready var tileMap : TileMap = $TileMap
@onready var timeOfDay: Node2D = $TimeOfDay

@onready var catPoints : Node2D =  $Cats
@onready var VendingPoints: Node2D = $VendingMachinePoints
@onready var LeafPilePoints: Node2D = $LeafPiles
@onready var DotDPoints: Marker2D = $DotDBand
@onready var CoffeeShopPoint: Marker2D = $CoffeeShopPoint

@onready var cat = preload("res://Characters/Cat.tscn")
@onready var vending = preload("res://Objects/Shops/VendingMachine.tscn")
@onready var DotDBand = preload("res://Characters/DotDDancers.tscn")
@onready var coffeeShop = preload("res://Objects/Shops/CoffeeShop.tscn")
@onready var LeafPile = preload("res://Objects/LeafPile.tscn")

@onready var letter = preload("res://Scenes/Letter.tscn")

@onready var ui : CanvasLayer = $UI
@onready var tween : Tween

func _ready():
	Game.connect("_ShowPumpkins",_ShowPumpkins)
	Game.connect("_ShowYourPumpkins",_ShowYourPumpkins)
	Game.connect("_AddBlackCats", _AddBlackCats)
	Game.connect("_AddVendingMachines", _AddVendingMachines)
	Game.connect("_DayOfTheDead", _DayOfTheDead)
	Game.connect("_AddCemetery", _AddCemetery)
	Game.connect("_AddScarecrows", _AddScarecrows)
	Game.connect("_AddPumpkinPatch", _AddPumpkinPatch)
	Game.connect("_AddCoffeeShop", _AddCoffeeShop)
	Game.connect("_AddGarland", _AddGarland)
	Game.connect("_AddLeafPile", _AddLeafPile)
	call_deferred("openingScence")
	
func openingScence():
	Game.CanMove = false
	tween = create_tween()
	tween.tween_callback(player.OpeningScene1)
	tween.tween_property(player, "position", Vector2(80, 220), 2)
	tween.tween_callback(player.OpeningScene2)
	tween.tween_property(player, "position", Vector2(95, 220), .5)
	await tween.tween_callback(player.OpeningScene3).finished
	
	
	DialogueManager.startDialogue(Vector2(175, 230), ["It's spooky season again! ","I can't wait to carve pumpkins","and get pumpkin spice lattes and ..."], speachSound)
	DialogueManager.finishedDisplaying.connect(openLetter)

func openLetter():
	if DialogueManager.finishedDisplaying.is_connected(openLetter):
		DialogueManager.finishedDisplaying.disconnect(openLetter)
	Game.CanMove = false
	var _letter = letter.instantiate()
	add_child(_letter)
	_letter.connect("closedLetter", solveProblem)
	pass	

func solveProblem():
	Game.CanMove = false
	DialogueManager.startDialogue(Vector2(175, 230), ["Maybe if I sell enough pumpkins I can help decorate the town", "and get it ready for the spooky season."], speachSound)
	DialogueManager.finishedDisplaying.connect(startDay)
	pass

func startDay():	
	Game.CanMove = true
	timeOfDay.playTimeOfDay()
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
	
func _AddGarland():
	tileMap.set_layer_enabled(10, true)
	pass

func _AddBlackCats():
	for p in catPoints.get_children():
		var _cat = cat.instantiate()
		_cat.position = p.position
		add_child(_cat)
	pass
	
func _AddLeafPile():
	for p in LeafPilePoints.get_children():
		var _leafPile = LeafPile.instantiate()
		_leafPile.position = p.position
		add_child(_leafPile)
	
func _DayOfTheDead():
	var _dotd = DotDBand.instantiate()
	_dotd.global_position = DotDPoints.global_position
	_dotd.scale = Vector2(.6, .6)
	add_child(_dotd)
	pass
	
func _AddCoffeeShop():
	var _coffee = coffeeShop.instantiate()
	_coffee.global_position = CoffeeShopPoint.global_position
	add_child(_coffee)
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
