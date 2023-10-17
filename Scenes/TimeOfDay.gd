extends Node2D

var ChangeState = false

@export var LengthOfDay = 25
@export var LengthOfEvening = 10
@export var LengthOfNight = 10

@onready var timer : Timer = $Timer
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	playTimeOfDay()

func setTimeOfDay():
	match Game.CurrentTimeOfDay:
		Game.TimeOfDay.Day:
			Game.CurrentTimeOfDay = Game.TimeOfDay.Evening
			pass
		Game.TimeOfDay.Evening:
			Game.CurrentTimeOfDay = Game.TimeOfDay.Night
			pass
		Game.TimeOfDay.Night:
			Game.CurrentTimeOfDay = Game.TimeOfDay.Day
	
	playTimeOfDay()
	
func playTimeOfDay():
	match Game.CurrentTimeOfDay:
		Game.TimeOfDay.Day:
			timer.start(LengthOfDay)
			if Game.playNightAnimation:
				animation.play("NightToDay")
			pass
		Game.TimeOfDay.Evening:
			timer.start(LengthOfNight)
			if Game.playNightAnimation:
				animation.play("DayToEvening")
			pass
		Game.TimeOfDay.Night:
			timer.start(LengthOfEvening)
			if Game.playNightAnimation:
				animation.play("EveningToNight")
	
	#TODO optomize to only play if AlwayDay wasn't the last thing played			
	if !Game.playNightAnimation:
		animation.play("AlwaysDay")
