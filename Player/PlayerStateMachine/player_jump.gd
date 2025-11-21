extends State
class_name PlayerJump

@export var anim : AnimationPlayer
@export var particles : GPUParticles2D

@export var boomSound: AudioStreamPlayer2D
@export var boomLight : PointLight2D
@export var bombBootParticles : GPUParticles2D

var jumpKilled : bool = false
func enter(_prevState):
	var p : Player = parent as Player
	
	if PlayerStats.bombBootsRadius > 0:
		if Input.is_action_pressed("Jump"):# and abs(parent.prevVelocity.y) > 120.0:
			explode()
	
	if !PlayerStats.canMove:
		if PlayerStats.bombBootsRadius > 0:
			p.jump()
		await get_tree().process_frame
		transitioned.emit(self, "Fly")
		return
	
	anim.play("StartOfJump")
	p.jump()
	jumpKilled = false
	if !Input.is_action_pressed("Jump"):
		p.jumpVelocity.y /= 2.0
		jumpKilled = true
	
	particles.restart()
	particles.emitting = true

func update(_delta : float):
	var p : Player = parent as Player
	var SM : PlayerStateMachine = sm as PlayerStateMachine
	
	p.align()
	
	
	
	if Input.is_action_just_released("Jump") and jumpKilled == false:
		p.jumpVelocity.y /= 2.0
		jumpKilled = true
	
	if Input.is_action_just_pressed("Jump") and SM.flightTime > 0:
		transitioned.emit(self, "Fly")
		return
	
	if Input.is_action_pressed("Jump") and SM.flightTime > 0 and abs(p.jumpVelocity.y) < 30.0:
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
	

func explode():
	bombBootParticles.emitting = true
	boomSound.play()
	var detroyedTiles : Dictionary[int, int] = TerrainDestruction.addTileRadius(parent.global_position, -1, PlayerStats.bombBootsRadius, TerrainRendering.LAYER_TYPE.FOREGROUND)
	Game.amountOfFuel += detroyedTiles[2]
	
	if is_instance_valid(Game.camera):
		Game.camera.setMinimumShake(10.0)
	
	boomLight.texture_scale = 1.0
	create_tween().tween_property(boomLight, "texture_scale", 0.0, 0.3)
