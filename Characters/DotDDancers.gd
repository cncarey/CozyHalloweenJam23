extends StaticBody2D

@onready var ani1 = $AnimatedSprite2D
@onready var ani2 = $AnimatedSprite2D2
@onready var ani3 = $AnimatedSprite2D3
@onready var ani4 = $AnimatedSprite2D4
@onready var ani5 = $AnimatedSprite2D5

func _ready():
	ani1.play("default")
	ani2.play("default")
	ani3.play("default")
	ani4.play("default")
	ani5.play("default")
	
	setTimeOfDay(Game.CurrentTimeOfDay)
	Game.connect("CurrentTimeOfDayChanged",setTimeOfDay)
	
func setTimeOfDay(tod):
	#TODO tween them in and out
	
	match tod:
		Game.TimeOfDay.Day:
			self.visible = false
			pass #hide
		Game.TimeOfDay.Night:
			self.visible = true
			pass #show
		Game.TimeOfDay.Evening:
			self.visible = true
			pass #show
