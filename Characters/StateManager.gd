class_name  StateManager

var states = {
	"idle" : IdleState,
	"run" : RunState
}

func getState(stateName: String):
	if states.has(stateName):
		return states.get(stateName)
	else:
		printerr("No State ", stateName, " existis")
	pass
