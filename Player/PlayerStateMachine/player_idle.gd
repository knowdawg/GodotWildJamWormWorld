extends State
class_name PlayerIdle

@export var anim : AnimationPlayer

func enter(prevState : State):
	if prevState is PlayerFall:
		anim.play("JumpLand")
		anim.queue("Idle")
	else:
		anim.play("Idle")

func update(_delta : float):
	var p : Player = parent as Player
	var SM : PlayerStateMachine = sm as PlayerStateMachine
	
	if p.jumpVelocity.y > 0 and !p.is_on_floor():
		transitioned.emit(self, "Fall")
		return
	
	if SM.inputBuffer == SM.INPUTS.JUMP and SM.canJump:
		transitioned.emit(self, "Jump")
		return
	
	if SM.inputBuffer == SM.INPUTS.BOMB and p.is_on_floor():
		transitioned.emit(self, "PlaceBomb")
		return
	
	if abs(p.walkVelocity.x) > 0:
		transitioned.emit(self, "Walk")
		return

func update_physics(delta: float):
	var p : Player = parent as Player
	
	p.playerAgencyPhysicsUpdate(delta)
