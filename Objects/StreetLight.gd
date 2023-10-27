extends StaticBody2D

@onready var garland : Sprite2D = $garland
@onready var light : PointLight2D = $PointLight2D

@onready var tween : Tween

func _ready():
	setTimeOfDay(Game.CurrentTimeOfDay)
	Game.connect("CurrentTimeOfDayChanged",setTimeOfDay)
	Game.connect("_AddGarland", _AddGarland)
	
func _AddGarland():
	garland.visible = true
	pass

func setTimeOfDay(tod):
	#TODO put on your halloween costume if you have unlocked it
	
	if tween:
		tween.kill()
	
	match tod:
		Game.TimeOfDay.Day:
			tween = create_tween()
			await tween.tween_property(light, "energy",0, 3).finished
		Game.TimeOfDay.Night:
			if Game.playNightAnimation:
				pass
		Game.TimeOfDay.Evening:
			if Game.playNightAnimation:
				tween = create_tween()
				await tween.tween_property(light, "energy",.25, 3).finished
				
	if !Game.playNightAnimation:
		light.enabled = false
