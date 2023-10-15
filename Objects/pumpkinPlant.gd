extends Area2D

@onready var timer = $Timer
@onready var plant = $plant

enum GrowingStage { seed = 0}

@export var stage = 0
var isTouching: bool = false

signal Harvested()

func _ready():
	timer.start(Game.GrowSpeed)
	plant.frame = 101
	
func _process(_delta):
	match stage:
		1:
			plant.frame = 100
		2:
			plant.frame = 99
		3:
			plant.frame = 98
		4: 
			plant.frame = 97
		#5:
			#plant.frame = 96


func goToNextStage():
	if stage <= 5:
		stage += 1
		timer.start(Game.GrowSpeed)
	pass 
	

func plantEntered(_body):
	isTouching = true
	#TouchIndicator.show()
	pass # Replace with function body.

func plantExited(_body):
	isTouching = false
	#TouchIndicator.hide()
	pass
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") && isTouching && stage >= 4:
		Game.CurrentPumpkins += 1
		Harvested.emit()
		queue_free()
