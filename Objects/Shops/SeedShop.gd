extends StaticBody2D

var isTouching: bool = false

@onready var CurrentSeeds = 10 : 
	set (value):
		CurrentSeeds = min(0, value)
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

func doorEntered(_body):
	isTouching = true
	#TouchIndicator.show()
	pass # Replace with function body.

func doorExited(_body):
	isTouching = false
	#TouchIndicator.hide()
	pass
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") && isTouching:
		var _cur = CurrentSeeds
		if tryRemoveSeeds(_cur):
			Game.CurrentSeeds += _cur
