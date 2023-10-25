extends Area2D

@onready var timer = $Timer
@onready var plant = $plant

enum GrowingStage { seed = 0}

@export var stage = 0
var isTouching: bool = false
var hasFruit : bool = true
var isRotten: bool = false
signal Harvested()

func _ready():
	timer.start(getGrowSpeed())
	plant.frame = 101
	
func _process(_delta):
	match stage:
		1:
			plant.frame = 100
		2:
			plant.frame = 99
		3:
			plant.frame = 98
		4,5: 
			plant.frame = 97
		6:
			plant.frame = 84


func goToNextStage():
	if stage <= 3:
		stage += 1
		timer.start(getGrowSpeed())
	elif stage == 4: #startRotTimer
		stage += 1
		var timePerDay = Game.LengthOfDay + Game.LengthOfNight + Game.LengthOfEvening
		var daysToRot = 3 if Game.ActiveUpgrades.has(Game.ADD_SCARECROW) else 2
		timer.start(timePerDay * daysToRot)
	elif stage >= 5:
		stage +=1
		isRotten = true	
	
	pass 
	
func getGrowSpeed() -> int:
	if Game.ActiveUpgrades.has(Game.DECREASE_GROW_SPEED):
		return Game.GrowSpeed - Game.ActiveUpgrades.get(Game.DECREASE_GROW_SPEED)
	else:
		return Game.GrowSpeed
		
func plantEntered(_body):
	isTouching = true
	if stage >= 4:
		if plant.material != null:
			plant.material.set_shader_parameter("width", 1)

func plantExited(_body):
	isTouching = false
	if plant.material != null:
		plant.material.set_shader_parameter("width", 0)
	pass
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") && isTouching && stage >= 4 && hasFruit:
		hasFruit = false
		
		if !isRotten:
			Game.CurrentPumpkins += 1
		Harvested.emit()
		queue_free()

