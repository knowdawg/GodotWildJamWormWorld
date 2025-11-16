extends State
class_name PlayerJump

@export var anim : AnimationPlayer

var jumpKilled : bool = false
func enter(_prevState):
	anim.play("StartOfJump")
	
	var p : Player = parent as Player
	p.jump()
	jumpKilled = false
	if !Input.is_action_pressed("Jump"):
		p.jumpVelocity.y /= 2.0
		jumpKilled = true

func update(_delta : float):
	var p : Player = parent as Player
	
	p.align()
	
	
	
	if Input.is_action_just_released("Jump") and jumpKilled == false:
		p.jumpVelocity.y /= 2.0
		jumpKilled = true
	
	if Input.is_action_just_pressed("Jump"):
		transitioned.emit(self, "Fly")
		return
	
	if p.jumpVelocity.y > 0 and !p.is_on_floor():
		transitioned.emit(self, "Fall")
		return
	
	if p.jumpVelocity.y >= 0.0 and p.is_on_floor():
		transitioned.emit(self, "Idle")
		return

func update_physics(delta: float):
	var p : Player = parent as Player
	
	p.playerAgencyPhysicsUpdate(delta)
