extends MarginContainer

@onready var label : Label = $MarginContainer/Label
@onready var timer : Timer = $LetterDisplayTimer
@onready var sfxPlayer: AudioStreamPlayer = $AudioStreamPlayer

var MAX_WIDTH = 256

var text = ""
var letterIndex = 0

var letterTime = 0.02
var spaceTime = 0.04
var punctuationTime = 0.1

signal finishedDisplaying()

func _ready():
	self.scale = Vector2.ZERO

func displayText(textToDisplay: String, sfx: AudioStream):
	text = textToDisplay
	label.text = textToDisplay
	sfxPlayer.stream = sfx
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x /2
	global_position.y -= size.y + 24
	
	label.text = ""
	pivot_offset = Vector2(size.x /2, size.y)
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.15).set_trans(Tween.TRANS_BACK)
	
	displayLetter()
		
func displayLetter():
	label.text += text[letterIndex]
	letterIndex += 1
	
	if letterIndex >= text.length():
		finishedDisplaying.emit()
		return
	
	match text[letterIndex]:
		"!", ".", ",", ";", "?":
			timer.start(punctuationTime)
		" ":
			timer.start(spaceTime)
		_:
			timer.start(letterTime)
			var ap : AudioStreamPlayer = sfxPlayer.duplicate()
			ap.pitch_scale += randf_range(-.1, 1)
			if text[letterIndex] in ["a", "e", "i", "o", "u"]:
				ap.pitch_scale += 2
				
			get_tree().root.add_child(ap)
			ap.play()
			await  ap.finished
			ap.queue_free()
	pass


func _on_letter_display_timer_timeout():
	displayLetter()
	pass # Replace with function body.
