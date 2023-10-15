extends CharacterBody2D

enum AIState{ NONE, IDLE, WANDER, SEESPLAYER}

@onready var state = AIState.IDLE
@export var acceleration = 50

@onready var ani = $AnimatedSprite2D

@onready var wanderController = $WanderController
@onready var playerDetection = $PlayerDetectionZones
var skin: int = 1
var wantsPumpkinToday : bool = false

func _ready():
	randomize()
	skin = randi_range(1, 4)
	#pick a random number to determine the npc skin
	ani.play( str(skin) + "_idle")
	
	resetDay()

func resetDay():
	#TODO	determin if the users want a pumpkin today
	pass

func _physics_process(delta):
	match state:
		AIState.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
			ani.play(str(skin) + "_idle")
			ani.flip_h = velocity.x < 0
			
			seekPlayer()
			
			if wanderController.getTimeLeft() == 0:
				setRandomState()
			pass
		AIState.WANDER:
			seekPlayer()

			if wanderController.getTimeLeft() == 0:
				setRandomState()

			moveToPoint(wanderController.targetPosition, delta)
			ani.play(str(skin) + "_walk")
			ani.flip_h = velocity.x < 0

			if global_position.distance_to(wanderController.targetPosition) <= 2:
				setRandomState()
			pass
		AIState.SEESPLAYER:
			var player = playerDetection.player
			
			if player != null:
				var toPlayer = self.global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
				ani.play(str(skin) + "_idle")	
				ani.flip_h = toPlayer.x < 0
			else:
				state = AIState.IDLE						
				pass
			
	
	
	move_and_slide()

func moveToPoint(point: Vector2, delta):
	var direction = (self.global_position- Vector2(0, 15)).direction_to(point).normalized()
	velocity = direction * acceleration
	pass


func seekPlayer():
	if playerDetection.canSeePlayer():
		state = AIState.SEESPLAYER
	elif state == AIState.WANDER:
		pass
	else:
		state = AIState.IDLE
	pass

func pickRandomState(_states):
	_states.shuffle()
	return _states.pop_front()

func setRandomState():
	state = pickRandomState([AIState.IDLE, AIState.WANDER])
	print(state)
	wanderController.startTimer(randi_range(1, 5))
