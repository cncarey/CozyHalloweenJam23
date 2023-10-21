extends Sprite2D



func _ready():
	randomize()
	
	self.frame = randi_range(0, 2)
