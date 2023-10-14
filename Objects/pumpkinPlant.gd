extends Area2D

@onready var timer = $Timer
@onready var plant = $plant

enum GrowingStage { seed = 0}

@export var stage = 0

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
