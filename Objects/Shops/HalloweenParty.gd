extends StaticBody2D

@onready var PartierPoints: Node2D = $PartierPoints
@onready var Temp: Node2D = $TempObjects
var npc = preload("res://Characters/NPC.tscn")

func _ready():
	setTimeOfDay(Game.CurrentTimeOfDay)
	Game.connect("CurrentTimeOfDayChanged",setTimeOfDay)
	
func setTimeOfDay(tod):
	match tod:
		Game.TimeOfDay.Day:
			#get rid of anything that was made
			for c in Temp.get_children():
				c.call_deferred("queue_free")
				
			pass
		Game.TimeOfDay.Night:
			
			pass
		Game.TimeOfDay.Evening:
			#TODO only get in realation to the leve of upgrade
			#for cp in PartierPoints.get_children():
			var partierCount = (Game.ActiveUpgrades[Game.ADD_HALLOWEEN_PARTY] * 2) - 1 
			
			for indx in range(0, partierCount):
				var cp = PartierPoints.get_child(indx)
				var _customer = npc.instantiate()
				_customer.position = cp.position
				_customer.isIdleOnly = true
				Temp.call_deferred("add_child", _customer)
			pass
