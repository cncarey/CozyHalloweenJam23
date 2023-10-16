extends CharacterBody2D

enum AIState{ NONE, IDLE, WANDER, SLEEP}

@onready var state = AIState.IDLE
@export var acceleration = 20

@onready var ani = $AnimatedSprite2D

@onready var wanderController = $WanderController


func _ready():
	ani.play("idle")
	
	setTimeOfDay(Game.CurrentTimeOfDay)
	Game.connect("CurrentTimeOfDayChanged",setTimeOfDay)
	
func setTimeOfDay(tod):
	match tod:
		Game.TimeOfDay.Day:
			pass
		Game.TimeOfDay.Night:
			#make sleep at night
			pass
		Game.TimeOfDay.Evening:
			
			pass
		
	pass	

func _physics_process(delta):
	match state:
		AIState.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
			ani.flip_h = velocity.x < 0
			
			if wanderController.getTimeLeft() == 0:
				setRandomState()
			pass
		AIState.WANDER:
			if wanderController.getTimeLeft() == 0:
				setRandomState()

			moveToPoint(wanderController.targetPosition, delta)
			ani.flip_h = velocity.x > 0

			if global_position.distance_to(wanderController.targetPosition) <= 2:
				setRandomState()
			pass
	
	move_and_slide()

func moveToPoint(point: Vector2, _delta):
	var direction = (self.global_position- Vector2(0, 15)).direction_to(point).normalized()
	velocity = direction * acceleration
	pass

func pickRandomState(_states):
	_states.shuffle()
	return _states.pop_front()

func setRandomState():
	state = pickRandomState([AIState.IDLE, AIState.WANDER])
	wanderController.startTimer(randi_range(1, 5))

