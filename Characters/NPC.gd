extends CharacterBody2D

enum AIState{ NONE, IDLE, WANDER, SEESPLAYER}

@onready var state = AIState.IDLE
@export var acceleration = 50
@export var alwaysWantsPumpkins :bool = false
@export var speachSound : AudioStream

@onready var ani = $AnimatedSprite2D
@onready var pumkinNotif = $AnimatedSprite2D2

@onready var coinSound : AudioStreamPlayer = $CoinSound

@onready var wanderController = $WanderController
@onready var playerDetection = $PlayerDetectionZones

var isTouching: bool = false

var skin: int = 1

var pumpkinActivities ={
	0 : "make pumpkin soup",
	1 : "make pumpkin pie",
	2 : "carve a jack-o-lantern",
	3 : "make pumpkin bread",
	4 : "decoreate my house",
	5 : "roast pumpkin seeds",
	6 : "paint a pumpkin",
	7 : "make a pumpkin spiced latte",
	8 : "make pumpkin pasta",
	9 : "make pumpkin risotto",
	10 : "make pumpkin pancakes",
	11 : "make pumpkin slime",
	12 : "make pumpkin cinnamon rolls",
	13 : "make pumpkin scones",
	14 : "make pumpkin spiced cheesecake doughnuts",
	15 : "make pumpkin butter",
	16 : "make pumpkin cake",
	17 : "make a scarecrow",
	18 : "go pumpkin chuckin" 
}

signal PurchasedPumpkin()
var pumpkinActivitiyIndex = 0
@onready var wantsPumpkinToday: bool = false: 
	set (value):
		wantsPumpkinToday = value
		
		if wantsPumpkinToday && pumkinNotif != null:
			pumkinNotif.show()
			pass
		
		if wantsPumpkinToday:
			randomize()
			pumpkinActivitiyIndex = randi_range(0, 18)
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
	
	var curDesire = Game.PumpkinDesireLevel
	if Game.ActiveUpgrades.has(Game.INCREASE_PUMPKIN_DESIRE):
		match Game.ActiveUpgrades.get(Game.INCREASE_PUMPKIN_DESIRE):
			1:
				curDesire = Game.PUMPKIN_DESIRE_1
			2:
				curDesire = Game.PUMPKIN_DESIRE_2
			3:
				curDesire = Game.PUMPKIN_DESIRE_3	
	
	var wantsPumpkin = randi_range(1, curDesire)
	if alwaysWantsPumpkins:
		wantsPumpkinToday = true
	else:
		wantsPumpkinToday = wantsPumpkin == 1
	
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
	if ani.material != null:
		ani.material.set_shader_parameter("width", 1)
	pass 

func npcExited(_body):
	isTouching = false
	if ani.material != null:
		ani.material.set_shader_parameter("width", 0)
	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") && isTouching && Game.CurrentPumpkins > 0 && wantsPumpkinToday && !hasPumpkin:
		if Game.tryRemovePumpkins(1):
			hasPumpkin = true
			
			if Game.ActiveUpgrades.has(Game.INCREASE_COINS):
				Game.CurrentCoins += Game.CoinsPerSale + ceili( 0.5 * Game.CoinsPerSale * Game.ActiveUpgrades.get(Game.INCREASE_COINS))
			else:	
				Game.CurrentCoins += Game.CoinsPerSale
			
			coinSound.play()
			PurchasedPumpkin.emit()
	elif Input.is_action_just_pressed("interact") && isTouching && Game.CurrentPumpkins <= 0 && wantsPumpkinToday && !hasPumpkin:
			DialogueManager.startDialogue(global_position, ["Come see me when you get more pumpkins. I want to " + pumpkinActivities[pumpkinActivitiyIndex] + "."], speachSound)
	elif  Input.is_action_just_pressed("accept") && isTouching && wantsPumpkinToday && !hasPumpkin:
		DialogueManager.startDialogue(global_position, ["Do you have any pumpkins today? I want to " + pumpkinActivities[pumpkinActivitiyIndex] + "."], speachSound)
	
