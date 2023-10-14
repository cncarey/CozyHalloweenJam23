extends State

class_name IdleState

func moveLeft():
	changedState.call("Run")
	
func moveRight():
	changedState.call("Run")
	
func moveUp():
	changedState.call("Run")
	
func moveDown():
	changedState.call("Run")
