extends State
class_name PlayerLedgeGrab

@export var anim : AnimationPlayer

func enter(_prevState):
	anim.play("PeakOfJump")

func update(_delta : float):
	var p : Player = parent as Player
	var SM : PlayerStateMachine = sm as PlayerStateMachine
	
	#p.align()
	
	if SM.inputBuffer == SM.INPUTS.JUMP and SM.canJump:
		transitioned.emit(self, "Jump")
		return
	
	var input : float = Input.get_axis("MoveLeft", "MoveRight")
	var pushDirection : Vector2 = SM.ledgeRayCollision.target_position * SM.ledgeRayCollision.scale.x
	pushDirection = pushDirection.normalized()
	if input * pushDirection.x < 0: #if they dont match: +/- or +/-
		p.position += pushDirection * -2.0
		
		transitioned.emit(self, "Fall")

func update_physics(delta: float):
	var p : Player = parent as Player
	
	p.ledgeGrabPhysicsUpdate(delta)
