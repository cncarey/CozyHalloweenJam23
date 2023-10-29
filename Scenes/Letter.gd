extends CanvasLayer

signal closedLetter()

func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		closedLetter.emit()
		call_deferred("queue_free")
