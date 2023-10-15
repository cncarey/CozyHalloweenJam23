extends Area2D

var isTouching: bool = false
var hasSeed: bool = false

var pumpkinPlant = preload("res://Objects/pumpkinPlant.tscn")
@onready var point = $Marker2D

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
			var plant = pumpkinPlant.instantiate()
			plant.position = point.position
			add_child(plant)
			plant.connect("Harvested", Harvested)
		#TODO connect pumpkin bing harvested to the harvested method

func Harvested():
	await get_tree().create_timer(.1).timeout
	hasSeed = false
