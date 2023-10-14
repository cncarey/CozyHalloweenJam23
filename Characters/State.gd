extends Node2D

class_name State

var changedState
var persistantState : CharacterBody2D
var velocity = 0 

func _physics_process(_delta):
	pass

func setup(_changeState, _persistantState):
	self.changedState = _changeState
	self.persistantState = _persistantState
	
