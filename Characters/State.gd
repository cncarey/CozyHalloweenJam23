extends Node2D

class_name State

var changedState
var animation
var persistantState
var velocity = 0 

func _physics_process(delta):
#	persistantState.move_and_slide(persistantState.velocity, Vector2.UP)
	pass

func setup(_changeState, _animation, _persistantState):
	self.changedState = _changeState
	self.animation = _animation
	self.persistantState = _persistantState
	
