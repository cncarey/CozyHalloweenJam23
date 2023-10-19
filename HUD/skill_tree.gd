extends Control

@onready var skillName : Label = $Panel2/MarginContainer/VBoxContainer/SkillName
@onready var skillDescription : RichTextLabel = $Panel2/MarginContainer/VBoxContainer/SkillDescription
@onready var skillCost : Label = $Panel2/MarginContainer/SkillCost

func setInfo(info, curLevel):
	#TODO pass in a key from a dictionary in Game and get the info to display
	skillName.text = info["Name"]
	skillDescription.text = info["Description"]
	skillCost.text = str((curLevel + 1) * info["Cost"]) + " Coins"
	pass
	
func clearInfo():
	skillName.text = ""
	skillDescription.text = ""
	skillCost.text = ""
