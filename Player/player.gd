extends CharacterBody2D
class_name Player

@export var jumpHeight : float = 25.0
@export var jumpDistance : float = 20.0
@export var maxMoveSpeed : float = 70.0

var jumpForce : float:
	get: return (-2.0 * jumpHeight) / timeInAir
var g : float:
	get: return (2.0 * jumpHeight) / pow(timeInAir, 2.0)
var timeInAir : float:
	get: return jumpDistance / maxMoveSpeed

func _ready() -> void:
	PlayerStats.player = self
	Game.escapePodEntered.connect(enterEscapePod)
	
	$Camera2D.limit_left = 0.0
	$Camera2D.limit_top = 0.0
	$Camera2D.limit_right = TerrainRendering.mapSize.x
	$Camera2D.limit_bottom = TerrainRendering.mapSize.y
	

var walkVelocity := Vector2.ZERO
var jumpVelocity := Vector2.ZERO
var xInput : float = 0.0
var yInput : float = 0.0
func playerAgencyPhysicsUpdate(delta: float) -> void:
	processInputs(delta)
	fall(delta)
	
	if is_on_ceiling() and jumpVelocity.y < 0.0:
		jumpVelocity.y = 0.0
	
	velocity = walkVelocity + jumpVelocity
	
	if !%BumpRaycast.is_colliding() and is_on_wall() and velocity.y >= 0.0:
		position.y -= 2.0
	
	move_and_slide()

func playerAgencyNoFallPhysicsUpdate(delta: float) -> void:
	processInputs(delta)
	#fall(delta)
	
	if is_on_ceiling() and jumpVelocity.y < 0.0:
		jumpVelocity.y = 0.0
	
	velocity = walkVelocity + jumpVelocity
	
	if !%BumpRaycast.is_colliding() and is_on_wall() and velocity.y >= 0.0:
		position.y -= 2.0
	
	move_and_slide()

func noInputPhysicsUpdate(delta: float) -> void:
	walkVelocity = Vector2.ZERO
	fall(delta)
	
	if is_on_ceiling() and jumpVelocity.y < 0.0:
		jumpVelocity.y = 0.0
	
	velocity = walkVelocity + jumpVelocity
	
	move_and_slide()

func ledgeGrabPhysicsUpdate(_delta: float) -> void:
	walkVelocity = Vector2.ZERO
	jumpVelocity = Vector2.ZERO
	
	velocity = walkVelocity + jumpVelocity
	
	move_and_slide()

func processInputs(delta : float):
	xInput = Input.get_axis("MoveLeft", "MoveRight")
	yInput = Input.get_axis("MoveUp", "MoveDown")
	walkVelocity.x = xInput * maxMoveSpeed * delta * 60.0 * PlayerStats.maxMoveSpeedMultiplier

func fall(delta : float):
	jumpVelocity.y += delta * g * PlayerStats.gravityMultiplier
	if is_on_floor() and jumpVelocity.y > 0.0:
		jumpVelocity.y = 0.0

func jump():
	jumpVelocity.y = jumpForce * PlayerStats.jumpForceMultiplier

func align():
	if velocity.x > 0.0:
		%PlayerSprite.flip_h = false
		%LedgeRaycastCollisionCheck.scale.x = 1.0
		%LedgeRaycastSpaceCheck.scale.x = 1.0
		%BumpRaycast.scale.x = 1.0
	if velocity.x < 0.0:
		%PlayerSprite.flip_h = true
		%LedgeRaycastCollisionCheck.scale.x = -1.0
		%LedgeRaycastSpaceCheck.scale.x = -1.0
		%BumpRaycast.scale.x = -1.0

var glowStick = preload("res://Player/Scenes/glow_stick.tscn")
var flare = preload("res://Player/Scenes/flare.tscn")
func throwGlowstick():
	var gs : Glowstick = glowStick.instantiate()
	Game.addProjectile(gs)
	gs.global_position = global_position
	
	var throwDir : Vector2 = global_position - get_global_mouse_position()
	gs.setup(-throwDir.normalized(), 200.0)

func throwFlare():
	if PlayerStats.useFlare():
		var f : Flare = flare.instantiate()
		Game.addProjectile(f)
		f.global_position = global_position
		
		var throwDir : Vector2 = global_position - get_global_mouse_position()
		f.setup(-throwDir.normalized(), 350.0, global_position)


func enterEscapePod():
	$StateMachine.switchStates("Stun")
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Glowstick"):
		#throwGlowstick()
		throwFlare()
	
	if global_position.y > Game.wormHight + 100.0:
		die()
	
	queue_redraw()

func _draw() -> void:
	if dead:
		return
	
	var offset : float = float(PlayerStats.picaxeRadius + 1) / 2.0
	draw_circle(-%Picaxe.getDirectionVector() * offset, PlayerStats.picaxeRadius + 0.5, Color(1.0, 1.0, 1.0, 0.5), false, 0.5)
	draw_circle(-%Picaxe.getDirectionVector() * offset, PlayerStats.picaxeRadius + 0.5, Color(1.0, 1.0, 1.0, 0.1), true)
	
	#PickaxeAttack
	%PickaxeAttack.position = -%Picaxe.getDirectionVector() * offset
	var s : CircleShape2D = %CollisionShape2D.shape
	s.radius = PlayerStats.picaxeRadius + 0.5


func _on_hurtbox_area_entered(_area: Area2D) -> void:
	die()

var dead : bool = false
func die():
	if !dead:
		$StateMachine.switchStates("Die")
		
		%GeneralLight.visible = false
		%Directional.visible = false
		%Picaxe.visible = false
		%PlayerSprite.visible = false
		$ParticleEffects/DeathParticles.emitting = true
		
		Game.playerDead.emit()
		dead = true
