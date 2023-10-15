extends CharacterBody2D

class_name PersistentState

var state
var statageManager: StateManager
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var aniTree = $AnimationTree
@onready var aniState :AnimationNodeStateMachinePlayback = aniTree.get("parameters/playback")

@onready var grassSteps : AudioStreamPlayer = $GrassSteps
@onready var stepTimer: Timer = $StepTimer

@export var speed: float = 100.0

@export var isLite : bool = false
@onready var light : PointLight2D = $PointLight2D

func _ready():
	statageManager = StateManager.new()
	changeState("Idle")
	aniTree.active = true
	aniState.travel("Idle")
	
	setTimeOfDay(Game.CurrentTimeOfDay)
	Game.connect("CurrentTimeOfDayChanged",setTimeOfDay)
	
func getInput():
	if Input.is_action_just_pressed("left"):
		state.moveLeft()
		pass
	if Input.is_action_just_pressed("right"):
		state.moveRight()
		pass
	if Input.is_action_just_pressed("up"):
		state.moveUp()
		pass
	if Input.is_action_just_pressed("down"):
		state.moveDown()
		pass	

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		aniTree.set("parameters/Idle/blend_position", direction)
		aniTree.set("parameters/Run/blend_position", direction)
		
		if stepTimer.time_left <= 0:
			grassSteps.pitch_scale = randf_range(0.8, 1.2)
			grassSteps.play(0.5)
			stepTimer.start(2)
			pass
	else:
		#velocity = Vector2.ZERO
		grassSteps.stop()
		stepTimer.stop()
	
	getInput()
	velocity = direction.normalized() * speed
	move_and_slide()
	
	
func changeState(newStateName: String):
	if state != null:
		state.queue_free()
		
	state = statageManager.getState(newStateName).new()
	state.setup(Callable(self, "changeState"), self)
	aniState.travel(newStateName)
	
	state.name = str(newStateName)
	add_child(state)


func setTimeOfDay(tod):
	#TODO put on your halloween costume if you have unlocked it
	match tod:
		Game.TimeOfDay.Day:
			light.enabled = false
		Game.TimeOfDay.Night:
			light.enabled = true
		Game.TimeOfDay.Evening:
			light.enabled = true
		
