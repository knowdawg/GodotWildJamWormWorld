extends State
class_name PlayerFly

@export var anim : AnimationPlayer

@export var flightPower : float = 100.0

@export var maxFlightPower : float = 20.0

func enter(_prevState):
	anim.play("StartOfJump")

func update(delta : float):
	var p : Player = parent as Player
	var SM : PlayerStateMachine = sm as PlayerStateMachine
	
	p.align()
	
	if Input.is_action_pressed("Jump") and SM.flightTime > 0:
		SM.flightTime -= delta
		p.jumpVelocity.y += -flightPower * delta
		p.jumpVelocity.y = clamp(p.jumpVelocity.y, -maxFlightPower, 99999999.9)
	
	if p.jumpVelocity.y > 0 and !p.is_on_floor() and (!Input.is_action_pressed("Jump") or SM.flightTime <= 0):
		transitioned.emit(self, "Fall")
		return
	
	if p.is_on_floor():
		transitioned.emit(self, "Idle")
		return

func update_physics(delta: float):
	var p : Player = parent as Player
	
	p.playerAgencyPhysicsUpdate(delta)
