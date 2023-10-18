extends MarginContainer

@export var MaxSelected : int = 0
@onready var amount : Label = $MarginContainer/VBoxContainer/HBoxContainer2/Amount
@onready var currentPumpkins: SpinBox = $MarginContainer/VBoxContainer/HBoxContainer2/CurrentPumpkins

signal loadPumpkins(p)

func _ready():
	Game.CanMove = false
	if amount != null:
			amount.text = "/" + str(MaxSelected)
			
	if currentPumpkins != null:
		currentPumpkins.max_value = MaxSelected
		
func submit():
	loadPumpkins.emit(currentPumpkins.value)
	cancel()
			
func cancel():
	Game.CanMove = true
	queue_free()
