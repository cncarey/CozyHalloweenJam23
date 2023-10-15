extends CanvasLayer

@onready var SeedLabel = $VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/SeedHCB/Seeds
@onready var PumpkinLabel = $VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/PumpkinHCB/Pumpkins
@onready var CoinLabel = $VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/CoinHCB/Coins
@onready var TimeOfDayIcon = $VBoxContainer/MarginContainer2/MarginContainer/HBoxContainer/TimeOfDayIcon
@onready var TimeOfDayLabel = $VBoxContainer/MarginContainer2/MarginContainer/HBoxContainer/TimeOfDayLabel

@export var dayTexture : Texture
@export var eveningTexture : Texture
@export var nightTexture : Texture
		
@onready var SeedCount = Game.CurrentSeeds: 
	set (value):
		SeedCount = value
		if SeedLabel != null:
			SeedLabel.text = str(SeedCount)
		
		if(SeedCount <= 0):
			pass
	get:
		return SeedCount
		
@onready var PumpkinCount = Game.CurrentPumpkins: 
	set (value):
		PumpkinCount = value
		if PumpkinLabel != null:
			PumpkinLabel.text = str(PumpkinCount)
		
		if(PumpkinCount <= 0):
			pass
	get:
		return PumpkinCount
		
@onready var CoinCount = Game.CurrentCoins: 
	set (value):
		CoinCount = value
		if CoinLabel != null:
			CoinLabel.text = str(CoinCount)
		
		if(CoinCount <= 0):
			pass
	get:
		return CoinCount

@onready var CurrentTimeOfDay : Game.TimeOfDay = Game.CurrentTimeOfDay:
	set (value):
		CurrentTimeOfDay = value
		
		#TODO set label
		if TimeOfDayLabel != null:
			match CurrentTimeOfDay:
				Game.TimeOfDay.Day:
					TimeOfDayLabel.text = "Day"
				Game.TimeOfDay.Night:
					TimeOfDayLabel.text = "Night"
				Game.TimeOfDay.Evening:
					TimeOfDayLabel.text = "Evening"
					
		if TimeOfDayIcon != null:
			match CurrentTimeOfDay:
				Game.TimeOfDay.Day:
					TimeOfDayIcon.texture = dayTexture
				Game.TimeOfDay.Night:
					TimeOfDayIcon.texture = nightTexture
				Game.TimeOfDay.Evening:
					TimeOfDayIcon.texture = eveningTexture	
	get:
		return CurrentTimeOfDay
		
func _ready():
	SeedCount = Game.CurrentSeeds
	PumpkinCount = Game.CurrentPumpkins
	CoinCount = Game.CurrentCoins
	CurrentTimeOfDay = Game.CurrentTimeOfDay
	
	Game.connect("seedCountChanged",setSeedCount)
	Game.connect("pumpkinsCountChanged",setPumpkinCount)
	Game.connect("coinsCountChanged", setCoinCount)
	Game.connect("CurrentTimeOfDayChanged", setCurrentTimeOfDay)

func setSeedCount(sc):
	SeedCount = sc

func setPumpkinCount(pc):
	PumpkinCount = pc

func setCoinCount(cc):
	CoinCount = cc

func setCurrentTimeOfDay(ctod):
	CurrentTimeOfDay = ctod
