extends State
class_name PlayerDialog



@export var anim : AnimationPlayer

func enter(_prevState : State):
	anim.play("Idle")


func update_physics(delta: float):
	var p : Player = parent as Player
	
	p.noInputPhysicsUpdate(delta)
