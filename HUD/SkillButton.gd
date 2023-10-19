extends TextureButton

class_name SkillNode

@onready var panel : Panel = $Panel
@onready var progressLabel: Label = $MarginContainer/ProgressLabel

@onready var costMargin : MarginContainer = $MarginContainer2
@onready var cost: Label = $MarginContainer2/HBoxContainer/cost
@onready var line : Line2D = $Line2D
@onready var levelUpSound : AudioStreamPlayer = $AudioStreamPlayer

var maxLevel : int = 1
var skillData
@export var skillName: String = ""


var level : int = 0:
	set(value):
		level = value
		
		if progressLabel != null:
			progressLabel.text = str(min( level, maxLevel)) + "/" + str(maxLevel)
			
		if level == maxLevel:
			costMargin.hide()
			
		if cost != null && skillData != null:
			cost.text = str(getCost())
		#TODO when we update the level update the cost
		
	get:
		return level
		
func _ready():
	if get_parent() is SkillNode:
		line.add_point(global_position + size/2)
		line.add_point(get_parent().global_position + size/2)
		
	if skillName != "" && Game.Upgrades.has(skillName):
		skillData = Game.Upgrades.get(skillName)
		maxLevel = skillData["Levels"]
		self.tooltip_text = skillData["Name"]
		
	if skillName != "" && Game.ActiveUpgrades.has(skillName):
		var activeSkill = Game.ActiveUpgrades.get(skillName)
		
		if activeSkill is int:
			level = activeSkill
		elif activeSkill is bool:
			level = 1
		else:
			level = 0
	else:
		level = 0
		
	if level > 0:
		self.button_pressed = true
		onPress()
func getCost() -> int:
	return (level + 1) * skillData["Cost"]
	
func increaseLevel():
	#check if you have enough money 
	if level < maxLevel:
		if Game.tryRemoveCoins(getCost()):
			level += 1
			levelUpSound.play()
			Game.call(skillData["Callable"])
			onPress()
		else:
			self.button_pressed = false
	
func onPress():
	panel.show_behind_parent = true
	line.default_color = Color.html("ffff52")
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and level == 1:
			skill.disabled = false

signal onHoverStart(skillData)
signal onHoverStop()

func _on_mouse_entered():
	onHoverStart.emit(skillData, level)
	


func _on_mouse_exited():
	onHoverStop.emit()
	pass # Replace with function body.
