extends Node2D

@export var wanderDistance: Vector2 = Vector2(5, 5)

@onready var startPosition
@onready var targetPosition

@onready var timer = $Timer

func _ready():
	startPosition = self.global_position
	updateTargetPosition()

func updateTargetPosition():
	var targetVector = Vector2(randi_range(-wanderDistance.x, wanderDistance.x)*10,randi_range(-wanderDistance.y, wanderDistance.y)*10)
	targetPosition = startPosition + targetVector
	
func getTimeLeft():
	return timer.time_left

func startTimer(duration):
	timer.start(duration)

func _on_timer_timeout():
	updateTargetPosition()
