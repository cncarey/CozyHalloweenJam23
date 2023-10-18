extends Node
var playNightAnimation = true

var ActiveUpgrades = {}
#player
const DECREASE_GROW_SPEED = "decrease_grow_speed"
func DecreaseGrowSpeed():
	if ActiveUpgrades.has(DECREASE_GROW_SPEED):
		var curGrowSpeed = ActiveUpgrades[DECREASE_GROW_SPEED] + 1
		ActiveUpgrades[DECREASE_GROW_SPEED] =  min(curGrowSpeed, GrowSpeed -1)
	else:
		ActiveUpgrades[DECREASE_GROW_SPEED] = 1
	pass

signal _ShowPumpkins()
const SHOW_PUMPKINS = "show_pumpkins"
func ShowPumpkins():
	ActiveUpgrades[SHOW_PUMPKINS] = true
	_ShowPumpkins.emit()
	pass
	
const INCREASE_COINS = "increase_coins"
func IncreaseCoins():
	if ActiveUpgrades.has(INCREASE_COINS):
		ActiveUpgrades[INCREASE_COINS] += 1
	else:
		ActiveUpgrades[INCREASE_COINS] = 1
	pass
	
const INCREASE_SHOP_SEEDS = "increase_shop_seeds"
func IncreaseShopSeeds():
	if ActiveUpgrades.has(INCREASE_SHOP_SEEDS):
		ActiveUpgrades[INCREASE_SHOP_SEEDS] += 1
	else:
		ActiveUpgrades[INCREASE_SHOP_SEEDS] = 1
	pass

#it's less of a pain to do this then calculate the fibo seq
const PUMPKIN_DESIRE_1 = 3
const PUMPKIN_DESIRE_2 = 2
const PUMPKIN_DESIRE_3 = 1

const INCREASE_PUMPKIN_DESIRE = "increase_pumpkin_desire"
func IncreasePumpkinDesire():
	if ActiveUpgrades.has(INCREASE_PUMPKIN_DESIRE):
		ActiveUpgrades[INCREASE_PUMPKIN_DESIRE] += 1
	else:
		ActiveUpgrades[INCREASE_PUMPKIN_DESIRE] = 1
	pass

#town
const ADD_BUS_STOPS = "add_bus_stops"
func AddBusStop():
	if ActiveUpgrades.has(ADD_BUS_STOPS):
		var curBusStops = ActiveUpgrades[ADD_BUS_STOPS] + 1
		ActiveUpgrades[ADD_BUS_STOPS] =  min(curBusStops, 3)
	else:
		ActiveUpgrades[ADD_BUS_STOPS] = 1
	pass

const ADD_VENDING_MACHINES = "add_vending_machines"
func AddVendingMachines():
	if ActiveUpgrades.has(ADD_VENDING_MACHINES):
		var curVendingMachines = ActiveUpgrades[ADD_VENDING_MACHINES] + 1
		ActiveUpgrades[ADD_VENDING_MACHINES] =  min(curVendingMachines, 3)
	else:
		ActiveUpgrades[ADD_VENDING_MACHINES] = 1
	pass

#decorations
const ADD_JACK_O_LANTERNS = "add_jack_o_lanterns"
func AddJackOLanterns():
	ActiveUpgrades[ADD_JACK_O_LANTERNS] = true
	pass

const DAY_OF_THE_DEAD = "day_of_the_dead"
func DayOfTheDead():
	ActiveUpgrades[DAY_OF_THE_DEAD] = true
	pass

const ADD_COSTUMES = "add_costumes"
func AddCostumes():
	ActiveUpgrades[ADD_COSTUMES] = true
	pass

signal _AddBlackCats()
const ADD_BLACK_CATS = "add_black_cats"
func AddBlackCats():
	ActiveUpgrades[ADD_BLACK_CATS] = true
	_AddBlackCats.emit()
	pass

const ADD_PUMPKIN_CAFE = "add_pumpin_cafe"
func AddPumpkinCafe():
	ActiveUpgrades[ADD_PUMPKIN_CAFE] = true
	pass

const ADD_TRICK_OR_TREAT = "add_trick_or_treat"
func AddTrickOrTreat():
	ActiveUpgrades[ADD_TRICK_OR_TREAT] = true
	pass
	
const ADD_PUMPKIN_PATCH = "add_pumpkin_patch"
func AddPumpkinPatch():
	ActiveUpgrades[ADD_PUMPKIN_PATCH] = true
	pass

var GrowSpeed = 4
var PumpkinDesireLevel = 4
var MinShopSeeds = 10
var MaxShopSeeds = 15
var CoinsPerSale = 30

enum TimeOfDay {Day, Evening, Night}
@onready var CurrentTimeOfDay : TimeOfDay = TimeOfDay.Day:
	set (value):
		CurrentTimeOfDay = value
		CurrentTimeOfDayChanged.emit(CurrentTimeOfDay)
	get:
		return CurrentTimeOfDay
		
signal CurrentTimeOfDayChanged(tod)
		
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

var Upgrades = {
	"skillName": { 
		"Name" : "Skill Name",
		"Description" : "Tooltip description to display",
		"Levels" : 1,
		"Cost" : 0,
		"Callable" : "Call to make when this skill is active"
	},
	"decrease_grow_speed": {
		"Name" : "Pumpkin Grow Speed",
		"Description" : "Pumpkins growing stages time decrease",
		"Levels" : 3,
		"Cost" : 200,
		"Callable" : "DecreaseGrowSpeed"
	},
	"show_pumpkins":{
		"Name" : "Pumpkins At Home",
		"Description" : "Decorate your home with pumpkins",
		"Levels" : 1,
		"Cost" : 50,
		"Callable" : "ShowPumpkins"
	},
	"increase_coins": {
		"Name" : "Pumpkin Sell For More",
		"Description" : "Pumpkins sell in vending machines and to neighbors for more coins",
		"Levels" : 3,
		"Cost" : 200,
		"Callable" : "IncreaseCoins"
	},
	"increase_shop_seeds": {
		"Name" : "More Seeds in the Shop",
		"Description" : "The pumpkins shop stocks more seeds",
		"Levels" : 3,
		"Cost" : 150,
		"Callable" : "IncreaseShopSeeds"
	},
	"increase_pumpkin_desire": {
		"Name" : "Increase Pumpkin Needs",
		"Description" : "Increase the likelyhood that neighbors will want pumpkins each day",
		"Levels" : 3,
		"Cost" : 250,
		"Callable" : "IncreasePumpkinDesire"
	},
	"add_bus_stops": {
		"Name" : "Bus Stops",
		"Description" : "A bus stop will be added to your house and other places around town",
		"Levels" : 3,
		"Cost" : 250,
		"Callable" : "AddBusStop"
	},
	"add_vending_machines" : {
		"Name" : "Vending Machines",
		"Description" : "Add vending machines around town to sell your pumpkins",
		"Levels" : 3,
		"Cost" : 250,
		"Callable" : "AddVendingMachines"
	},
	"add_jack_o_lanterns" : {
		"Name" : "Pumpkins Around Town",
		"Description" : "Decorate the town with pumpkins",
		"Levels" : 1,
		"Cost" : 250,
		"Callable" : "AddJackOLanterns"
	},
	"add_black_cats" : {
		"Name" : "Furry Feline Friends",
		"Description" : "Black cats appear around town",
		"Levels" : 1,
		"Cost" : 250,
		"Callable" : "AddBlackCats"
	}
}

func reset():
	self.CurrentCoins = 0
	self.CurrentPumpkins = 0
	self.CurrentSeeds = 10
	self.CurrentTimeOfDay = TimeOfDay.Day
	
	self.ActiveUpgrades = {}
