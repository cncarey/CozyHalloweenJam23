extends State

class_name RunState


func getInput():
	
	if !Input.is_action_pressed("up") && !Input.is_action_pressed("down") && !Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		changedState.call("Idle")
	pass
	
func _physics_process(_delta):
	getInput()
	
func moveLeft():
	#persistantState.velocity.x -= 1
	pass
	
func moveRight():
	#persistantState.velocity.x += 1
	pass
	
func moveUp():
	#persistantState.velocity.x -= 1
	pass
	
func moveDown():
	#persistantState.velocity.x += 1
	pass
	
