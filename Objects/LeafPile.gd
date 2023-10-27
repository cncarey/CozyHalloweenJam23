extends Area2D

@onready var leafEffect = preload("res://Objects/leafFly.tscn")
@onready var leafSound :AudioStreamPlayer = $AudioStreamPlayer


func pileEntered(body):
	var leaf = leafEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(leaf)
	leafSound.play()
	leaf.global_position = Vector2(self.global_position.x, self.global_position.y - 10)
