extends Node

var CurrentDay
var Plot
var Harvests

var GrowSpeed = 3
var PumpkinDesireLevel = 8

@onready var CurrentSeeds = 10 : 
	set (value):
		CurrentSeeds = value
		seedCountChanged.emit(CurrentSeeds)
		if(CurrentSeeds <= 0):
			noSeeds.emit()
	get:
		return CurrentSeeds
		
func tryRemoveSeeds(decrease) -> bool:
	if CurrentSeeds == 0 || CurrentSeeds - decrease < 0:
		return false
	else:
		CurrentSeeds -= decrease
		return true

signal noSeeds()
signal seedCountChanged(seeds)

@onready var CurrentPumpkins = 0 : 
	set (value):
		CurrentPumpkins = value
		pumpkinsCountChanged.emit(CurrentPumpkins)
		if(CurrentPumpkins <= 0):
			noPumpkins.emit()
	get:
		return CurrentPumpkins
		
func tryRemovePumpkins(decrease) -> bool:
	if CurrentPumpkins == 0 || CurrentPumpkins - decrease < 0:
		return false
	else:
		CurrentPumpkins -= decrease
		return true

signal noPumpkins()
signal pumpkinsCountChanged(pumpkins)

@onready var CurrentCoins = 0 : 
	set (value):
		CurrentCoins = value
		coinsCountChanged.emit(CurrentCoins)
		if(CurrentCoins <= 0):
			noCoins.emit()
	get:
		return CurrentCoins
		
func tryRemoveCoins(decrease) -> bool:
	if CurrentCoins == 0 || CurrentCoins - decrease < 0:
		return false
	else:
		CurrentCoins -= decrease
		return true

signal noCoins()
signal coinsCountChanged(coins)
