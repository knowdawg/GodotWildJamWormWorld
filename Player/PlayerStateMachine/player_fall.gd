extends State
class_name PlayerFall

@export var anim : AnimationPlayer

func enter(_prevState):
	anim.play("PeakOfJump")

func update(_delta : float):
	var p : Player = parent as Player
	var SM : PlayerStateMachine = sm as PlayerStateMachine
	
	p.align()
	
	
	if SM.inputBuffer == SM.INPUTS.JUMP and SM.canJump:
		transitioned.emit(self, "Jump")
		return
	
	if Input.is_action_pressed("Jump") and SM.flightTime > 0:
		transitioned.emit(self, "Fly")
		return
	
	if p.is_on_floor():
		transitioned.emit(self, "Idle")
		return
	
	#if SM.canLedgeGrab:
		#transitioned.emit(self, "LedgeGrab")
		#return

func update_physics(delta: float):
	var p : Player = parent as Player
	
	p.playerAgencyPhysicsUpdate(delta)
