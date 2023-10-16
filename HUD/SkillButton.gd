extends TextureButton

class_name SkillNode

@onready var panel : Panel = $Panel
@onready var progressLabel: Label = $MarginContainer/ProgressLabel
@onready var line : Line2D = $Line2D

@export var maxLevel : int = 3
@export var pricePerLevel: int = 100

var level : int = 0:
	set(value):
		level = value
		
		if progressLabel != null:
			progressLabel.text = str(level) + "/" + str(maxLevel)
			
	get:
		return level
		
func _ready():
	if get_parent() is SkillNode:
		line.add_point(global_position + size/2)
		line.add_point(get_parent().global_position + size/2)
		
	#TODO set the field associated with this	
#	if Game["CurrentSeeds"] != null:
#		level = min( Game["CurrentSeeds"], maxLevel)
#		if level > 0:
#			self.button_pressed = true
#			onPress()
			
func increaseLevel():
	#TODO check if you have enough money 
	level = min( level +1, maxLevel)
	onPress()
	
func onPress():
	panel.show_behind_parent = true
	line.default_color = Color.html("ffff52")
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and level == 1:
			skill.disabled = false
