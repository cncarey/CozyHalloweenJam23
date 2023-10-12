extends CharacterBody2D

class_name PersistentState

var state
var statageManager: StateManager
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

@export var speed: float = 100.0

func _ready():
	statageManager = StateManager.new()
	changeState("idle")
	
func getInput():
	if Input.is_action_just_pressed("left"):
		print("l")
		pass
	if Input.is_action_just_pressed("right"):
		print("r")
		pass
	if Input.is_action_just_pressed("up"):
		print("u")
		pass
	if Input.is_action_just_pressed("down"):
		print("d")
		pass	

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	
	getInput()
	velocity = direction.normalized() * speed
	move_and_slide()
	
	
func changeState(newStateName: String):
	if state != null:
		state.queue_free()
		
	state = statageManager.getState(newStateName).new()
	state.setup(Callable(self, "changeState"), animationPlayer, self)
	state.name = str(newStateName)
	add_child(state)
