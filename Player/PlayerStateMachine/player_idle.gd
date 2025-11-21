extends State
class_name PlayerIdle

@export var anim : AnimationPlayer
@export var particles : GPUParticles2D

@export var landSound : AudioStreamPlayer2D
@export var boomSound : AudioStreamPlayer2D

@export var boomLight : PointLight2D

func enter(prevState : State):
	if prevState is PlayerFall:
		particles.restart()
		particles.emitting = true
		anim.play("JumpLand")
		anim.queue("Idle")
		landSound.play()
	else:
		anim.play("Idle")
	
	#if PlayerStats.bombBootsRadius > 0:
		#if Input.is_action_pressed("Jump"):# and abs(parent.prevVelocity.y) > 120.0:
			#explode()
		

func update(_delta : float):
	var p : Player = parent as Player
	var SM : PlayerStateMachine = sm as PlayerStateMachine
	
	if p.jumpVelocity.y * -p.up_direction.y > 0 and !p.is_on_floor():
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


func explode():
	boomSound.play()
	var detroyedTiles : Dictionary[int, int] = TerrainDestruction.addTileRadius(parent.global_position, -1, PlayerStats.bombBootsRadius, TerrainRendering.LAYER_TYPE.FOREGROUND)
	Game.amountOfFuel += detroyedTiles[2]
	
	if is_instance_valid(Game.camera):
		Game.camera.setMinimumShake(10.0)
	
	boomLight.texture_scale = 1.0
	create_tween().tween_property(boomLight, "texture_scale", 0.0, 0.3)
	
	var p : Player = parent as Player
	
	p.knockbackVelocity = Vector2(0.0, p.jumpForce * PlayerStats.jumpForceMultiplier * 1.5)#p.prevVelocity * Vector2(1.0, -2.0)
	p.jumpVelocity = Vector2.ZERO
	print(p.knockbackVelocity)
	
	
	
