extends Node

@onready var textBoxScene = preload("res://HUD/textbox.tscn")

var diaglogLines : Array[String] = []
var currentLineIndex: int = 0

var textBox
var textBoxPosition : Vector2

var sfx : AudioStream

var isActive : bool = false
var canAdvanceNextLine : bool = false

func startDialogue(position: Vector2, lines : Array[String], speechSfx: AudioStream):
	if isActive:
		return
		
	textBoxPosition = position
	diaglogLines = lines
	sfx = speechSfx
	
	showTextBox()
	isActive= true
	Game.CanMove = false
	
	pass

func showTextBox():
	textBox = textBoxScene.instantiate()
	textBox.connect("finishedDisplaying", textBoxOnFinishDisaplay)
	get_tree().root.add_child(textBox)
	textBox.global_position = textBoxPosition
	textBox.displayText(diaglogLines[currentLineIndex], sfx)
	canAdvanceNextLine = false
	
signal finishedDisplaying()
	
func textBoxOnFinishDisaplay():
	canAdvanceNextLine = true
	
func _unhandled_input(event):
	if event.is_action_pressed("cancel") && isActive && canAdvanceNextLine:
		textBox.queue_free()
		
		currentLineIndex += 1
		if currentLineIndex >= diaglogLines.size():
			isActive = false
			currentLineIndex = 0
			Game.CanMove = true
			finishedDisplaying.emit()
			return
		else:
			showTextBox()
			
		
