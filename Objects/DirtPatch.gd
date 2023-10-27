extends Area2D

var isTouching: bool = false
var hasSeed: bool = false

@export var speachSound : AudioStream

var pumpkinPlant = preload("res://Objects/pumpkinPlant.tscn")
@onready var point = $Marker2D

@onready var seedingSound : AudioStreamPlayer = $seedSound
@onready var harvesSound : AudioStreamPlayer = $harvestSound

func patchEntered(_body):
	isTouching = true
	#TODO only show if !hasSeed
	#TouchIndicator.show()
	pass # Replace with function body.

func patchExited(_body):
	isTouching = false
	#TouchIndicator.hide()
	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") && isTouching && !hasSeed:
		if Game.tryRemoveSeeds(1):
			hasSeed = true
			seedingSound.play()
			var plant = pumpkinPlant.instantiate()
			plant.position = point.position
			add_child(plant)
			plant.connect("Harvested", Harvested)
		else:
			DialogueManager.startDialogue(global_position, ["I need to go to the seed shop soon."], speachSound)
		#TODO connect pumpkin bing harvested to the harvested method

func Harvested():
	harvesSound.play()
	await get_tree().create_timer(.1).timeout
	hasSeed = false
