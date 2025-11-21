extends State
class_name PlayerDialog

func update_physics(delta: float):
	var p : Player = parent as Player
	
	p.noInputPhysicsUpdate(delta)
