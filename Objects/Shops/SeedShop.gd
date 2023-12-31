extends StaticBody2D

var isTouching: bool = false

@onready var shop : Sprite2D = $Shop
@onready var seedPickUpSound : AudioStreamPlayer = $SeedPickUpSound

@onready var CurrentSeeds = 10 : 
	set (value):
		CurrentSeeds = max(0, value)
		if(CurrentSeeds <= 0):
			#noSeeds.emit() /set put up the sold out sign
			pass
	get:
		return CurrentSeeds

func tryRemoveSeeds(decrease) -> bool:
	if CurrentSeeds == 0 || CurrentSeeds - decrease < 0:
		return false
	else:
		CurrentSeeds -= decrease
		return true
		

func _ready():
	setTimeOfDay(Game.CurrentTimeOfDay)
	Game.connect("CurrentTimeOfDayChanged",setTimeOfDay)

func setTimeOfDay(tod):
	match tod:
		Game.TimeOfDay.Day:
			if Game.ActiveUpgrades.has(Game.INCREASE_SHOP_SEEDS):
				var minSeeds = Game.MinShopSeeds + ceili(0.5 * Game.MinShopSeeds * Game.ActiveUpgrades.get(Game.INCREASE_SHOP_SEEDS))
				var maxSeeds = Game.MaxShopSeeds + ceili(0.5 * Game.MaxShopSeeds * Game.ActiveUpgrades.get(Game.INCREASE_SHOP_SEEDS))
				CurrentSeeds = randi_range(minSeeds, maxSeeds)	
			else:	
				CurrentSeeds = randi_range(Game.MinShopSeeds, Game.MaxShopSeeds)	
		Game.TimeOfDay.Night:
			pass
		Game.TimeOfDay.Evening:
			pass
		

func doorEntered(_body):
	isTouching = true
	if shop.material != null:
		shop.material.set_shader_parameter("width", 1)
	pass # Replace with function body.

func doorExited(_body):
	isTouching = false
	if shop.material != null:
		shop.material.set_shader_parameter("width", 0)
	pass
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") && isTouching:
		var _cur = CurrentSeeds
		if tryRemoveSeeds(_cur):
			Game.CurrentSeeds += _cur
			seedPickUpSound.play()
