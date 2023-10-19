extends MarginContainer

@export var MaxSelected : int = 10
@onready var amount : Label = $MarginContainer/VBoxContainer/HBoxContainer2/Amount
@onready var currentPumpkins: SpinBox = $MarginContainer/VBoxContainer/HBoxContainer2/CurrentPumpkins

signal loadPumpkins(p)
signal cancelLoad()

func _ready():
	Game.CanMove = false
	if amount != null:
			amount.text = "/" + str(MaxSelected)
			
	if currentPumpkins != null:
		currentPumpkins.max_value = MaxSelected
		
func submit():
	loadPumpkins.emit(currentPumpkins.value)
	queue_free()
			
func cancel():
	cancelLoad.emit()
	queue_free()

func _unhandled_input(_event: InputEvent):
	if _event.is_action_released("up"):
		currentPumpkins.value += 1
	if  _event.is_action_released("down"):
		currentPumpkins.value -= 1
	if _event.is_action_released("accept"):
		submit()
	if _event.is_action_released("cancel"):
		cancel()
