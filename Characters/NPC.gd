extends CharacterBody2D

enum AIState{ NONE, IDLE, WANDER, SEESPLAYER}

@onready var state = AIState.IDLE
@export var acceleration = 50

@onready var ani = $AnimatedSprite2D
@onready var pumkinNotif = $AnimatedSprite2D2

@onready var wanderController = $WanderController
@onready var playerDetection = $PlayerDetectionZones
var isTouching: bool = false

var skin: int = 1

signal PurchasedPumpkin()

@onready var wantsPumpkinToday: bool = false: 
	set (value):
		wantsPumpkinToday = value
		
		if wantsPumpkinToday && pumkinNotif != null:
			pumkinNotif.show()
			pass
	get:
		return wantsPumpkinToday

@onready var hasPumpkin: bool = false: 
	set (value):
		hasPumpkin = value
		
		if hasPumpkin  && pumkinNotif != null:
			pumkinNotif.hide()
			pass
	get:
		return hasPumpkin

func _ready():
	randomize()
	skin = randi_range(1, 9)
	#pick a random number to determine the npc skin
	ani.play( str(skin) + "_idle")
	pumkinNotif.play("default")
	
	setTimeOfDay(Game.CurrentTimeOfDay)
	Game.connect("CurrentTimeOfDayChanged",setTimeOfDay)
	
func setTimeOfDay(tod):
	match tod:
		Game.TimeOfDay.Day:
			resetDay()
		Game.TimeOfDay.Night:
			
			pass
		Game.TimeOfDay.Evening:
			#TODO If the trick-or- treat skill is unlocked
			# set the use costume flag to true
			pass
		
	pass	

func resetDay():
	hasPumpkin = false
	pumkinNotif.hide()
	
	var wantsPumpkin = randi_range(1, Game.PumpkinDesireLevel)
	wantsPumpkinToday = wantsPumpkin == 1
	
	print(str(skin) + ": " + str(wantsPumpkinToday))
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

func moveToPoint(point: Vector2, _delta):
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
	wanderController.startTimer(randi_range(1, 5))

func npcEntered(_body):
	isTouching = true
	pass 

func npcExited(_body):
	isTouching = false
	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") && isTouching && Game.CurrentPumpkins > 0 && wantsPumpkinToday && !hasPumpkin:
		if Game.tryRemovePumpkins(1):
			hasPumpkin = true
			Game.CurrentCoins += 30
			PurchasedPumpkin.emit()
