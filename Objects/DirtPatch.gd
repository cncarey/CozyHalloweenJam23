extends Area2D

var isTouching: bool

var pumpkinPlant = preload("res://Objects/pumpkinPlant.tscn")
@onready var point = $Marker2D

func patchEntered(body):
	isTouching = true
	#TouchIndicator.show()
	pass # Replace with function body.

func patchExited(body):
	isTouching = false
	#TouchIndicator.hide()
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact") && isTouching:
		var plant = pumpkinPlant.instantiate()
		plant.position = point.position
		add_child(plant)

