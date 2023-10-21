extends StaticBody2D

@onready var cupPoints :Node2D = $CoffeeCupPoints
@onready var customerPoint: Node2D = $CustomerPoints
@onready var Temp: Node2D = $TempObjects

@onready var fire1 : AnimatedSprite2D = $Fire1
@onready var fire2 : AnimatedSprite2D = $Fire2
@onready var fire3 : AnimatedSprite2D = $FFire3s

@onready var fpSound1 : AudioStreamPlayer2D = $FirePit1
@onready var fpSound2 : AudioStreamPlayer2D = $FirePit2
@onready var fpSound3 : AudioStreamPlayer2D = $FirePit3

var cup = preload("res://Objects/CoffeeCup.tscn")
var npc = preload("res://Characters/NPC.tscn")
func _ready():
	fire1.play("default")
	fire2.play("default")
	fire3.play("default")
	
	setTimeOfDay(Game.CurrentTimeOfDay)
	Game.connect("CurrentTimeOfDayChanged",setTimeOfDay)

func setTimeOfDay(tod):
	match tod:
		Game.TimeOfDay.Day:
			for p in cupPoints.get_children():
				var _cup = cup.instantiate()
				_cup.position = p.position
				Temp.add_child(_cup)
				
			for cp in customerPoint.get_children():
				var _customer = npc.instantiate()
				_customer.position = cp.position
				Temp.add_child(_customer)
				
			setFire(fire1, fpSound1, false)
			setFire(fire2, fpSound2, false)
			setFire(fire3, fpSound3, false)
			pass
		Game.TimeOfDay.Night:
			#get rid of anything that was made
			for c in Temp.get_children():
				c.queue_free()
			setFire(fire1, fpSound1, false)
			setFire(fire2, fpSound2, false)
			setFire(fire3, fpSound3, false)
			
			pass
		Game.TimeOfDay.Evening:
			setFire(fire1, fpSound1, true)
			setFire(fire2, fpSound2, true)
			setFire(fire3, fpSound3, true)
			pass

func setFire(fire: AnimatedSprite2D, sound: AudioStreamPlayer2D, showing: bool):
	fire.visible = showing
	sound.playing = showing
