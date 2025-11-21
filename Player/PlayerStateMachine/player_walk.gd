extends State
class_name PlayerWalk

@export var anim : AnimationPlayer
@export var particles : GPUParticles2D

func enter(_prevState):
	anim.play("Walk")
	particles.emitting = true


func update(_delta : float):
	var p : Player = parent as Player
	var SM : PlayerStateMachine = sm as PlayerStateMachine
	
	p.align()
	
	if p.jumpVelocity.y * -p.up_direction.y > 0 and !p.is_on_floor():
		transitioned.emit(self, "Fall")
		return
	
	if SM.inputBuffer == SM.INPUTS.JUMP and SM.canJump:
		transitioned.emit(self, "Jump")
		return
		
	if SM.inputBuffer == SM.INPUTS.BOMB and p.is_on_floor():
		transitioned.emit(self, "PlaceBomb")
		return
	
	if abs(p.walkVelocity.x) == 0.0:
		transitioned.emit(self, "Idle")
		return

func update_physics(delta: float):
	var p : Player = parent as Player
	
	p.playerAgencyPhysicsUpdate(delta)

func exit(_newState):
	particles.emitting = false
