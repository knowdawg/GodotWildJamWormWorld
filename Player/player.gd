extends CharacterBody2D
class_name Player

@export var jumpHeight : float = 30.0
@export var jumpDistance : float = 25.0
@export var maxMoveSpeed : float = 70.0

var jumpForce : float:
	get: return (-2.0 * jumpHeight) / timeInAir
var g : float:
	get: return (2.0 * jumpHeight) / pow(timeInAir, 2.0)
var timeInAir : float:
	get: return jumpDistance / maxMoveSpeed

func _ready() -> void:
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
	walkVelocity.x = xInput * maxMoveSpeed * delta * 60.0

func fall(delta : float):
	jumpVelocity.y += delta * g
	if is_on_floor() and jumpVelocity.y > 0.0:
		jumpVelocity.y = 0.0

func jump():
	jumpVelocity.y = jumpForce

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
	var f : Flare = flare.instantiate()
	Game.addProjectile(f)
	f.global_position = global_position
	
	var throwDir : Vector2 = global_position - get_global_mouse_position()
	f.setup(-throwDir.normalized(), 350.0, global_position)


func enterEscapePod():
	$StateMachine.switchStates("Stun")
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Glowstick"):
		#throwGlowstick()
		throwFlare()
	
	queue_redraw()

func _draw() -> void:
	draw_circle(-%Picaxe.getDirectionVector() * 5.0, 9.5, Color(1.0, 1.0, 1.0, 0.5), false, 0.5)
	draw_circle(-%Picaxe.getDirectionVector() * 5.0, 9.5, Color(1.0, 1.0, 1.0, 0.1), true)
