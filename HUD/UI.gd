extends CanvasLayer

@onready var SeedLabel = $MarginContainer/MarginContainer/VBoxContainer/SeedHCB/Seeds
@onready var PumpkinLabel = $MarginContainer/MarginContainer/VBoxContainer/PumpkinHCB/Pumpkins
@onready var CoinLabel = $MarginContainer/MarginContainer/VBoxContainer/CoinHCB/Coins

		
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
		
func _ready():
	SeedCount = Game.CurrentSeeds
	PumpkinCount = Game.CurrentPumpkins
	CoinCount = Game.CurrentCoins
	
	Game.connect("seedCountChanged",setSeedCount)
	Game.connect("pumpkinsCountChanged",setPumpkinCount)
	Game.connect("coinsCountChanged", setCoinCount)

func setSeedCount(sc):
	SeedCount = sc

func setPumpkinCount(pc):
	PumpkinCount = pc

func setCoinCount(cc):
	CoinCount = cc
