extends CanvasLayer

@onready var SeedLabel = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer/Seeds
@onready var PumpkinLabel = $MarginContainer/NinePatchRect/VBoxContainer/HBoxContainer2/Pumpkins

		
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
		return SeedCount
		
@onready var CoinCount = Game.CurrentCoins: 
	set (value):
		CoinCount = value
		#if SeedLabel != null:
			#SeedLabel.text = str(CoinCount)
		
		if(CoinCount <= 0):
			pass
	get:
		return CoinCount
		
func _ready():
	SeedCount = Game.CurrentSeeds
	PumpkinCount = Game.CurrentPumpkins
	
	Game.connect("seedCountChanged",setSeedCount)
	Game.connect("pumpkinsCountChanged",setPumpkinCount)

func setSeedCount(sc):
	SeedCount = sc

func setPumpkinCount(pc):
	PumpkinCount = pc
