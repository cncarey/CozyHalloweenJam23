extends StaticBody2D

var isTouching: bool = false
var MaxPumpkins :int = 20
var popupOpened :bool = false

@onready var salesTimer :Timer = $Timer
@onready var stats : Label = $Stats

var howMany = preload("res://HUD/SelectMany.tscn")

@onready var CurrentPumpkins = 0 : 
	set (value):
		CurrentPumpkins = max(0, value)
		
		if stats != null:
			stats.text = str(CurrentPumpkins) + "/" + str(MaxPumpkins)
			
		if(CurrentPumpkins <= 0):
			#noSeeds.emit() //set put up the sold out sign
			pass
	get:
		return CurrentPumpkins

func tryRemovePumpkins(decrease) -> bool:
	if CurrentPumpkins == 0 || CurrentPumpkins - decrease < 0:
		return false
	else:
		CurrentPumpkins -= decrease
		return true
		
func makeSale():
	if tryRemovePumpkins(1):
		if Game.ActiveUpgrades.has(Game.INCREASE_COINS):
			Game.CurrentCoins += Game.CoinsPerSale + ceili( 0.5 * Game.CoinsPerSale * Game.ActiveUpgrades.get(Game.INCREASE_COINS))
		else:	
			Game.CurrentCoins += Game.CoinsPerSale
	
		if CurrentPumpkins > 0:
			salesTimer.start(randi_range(Game.MinVendingDuration, Game.MaxVendingDuration))
		
func loadPumpkins(increase):
	Game.CanMove = true
	if increase > 0 && popupOpened:
		popupOpened = false
		if Game.tryRemovePumpkins(increase):
			CurrentPumpkins += increase
			#play load sound
			
			salesTimer.start(randi_range(Game.MinVendingDuration, Game.MaxVendingDuration))
		
func cancelLoad():
	Game.CanMove = true
	popupOpened = false
	
func maxPumpkinLoad() -> int:
	return MaxPumpkins - CurrentPumpkins
	
func vendingEntered(_body):
	isTouching = true
	#TouchIndicator.show()
	pass # Replace with function body.

func vendingExited(_body):
	isTouching = false
	#TouchIndicator.hide()
	pass
	
signal OpenPopUp(popup)
func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") && isTouching && !popupOpened:
		var _mp  = min(Game.CurrentPumpkins, maxPumpkinLoad())
		var _howMany = howMany.instantiate()
		_howMany.MaxSelected = _mp
		#_howMany.global_position = self.global_position
		popupOpened = true
		OpenPopUp.emit(_howMany)
		_howMany.connect("loadPumpkins", loadPumpkins)
		_howMany.connect("cancelLoad", cancelLoad)
		#instantiate a transfer popup and set any values that need to be passed
		#Connect it to loadPumpkins
