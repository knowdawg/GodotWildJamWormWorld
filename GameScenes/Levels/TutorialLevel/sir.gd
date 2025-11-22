extends CharacterBody2D
class_name Sir

@export var jumpHeight : float = 25.0
@export var jumpDistance : float = 20.0
@export var maxMoveSpeed : float = 70.0

var jumpForce : float:
	get: return (-2.0 * jumpHeight) / timeInAir
var g : float:
	get: return (2.0 * jumpHeight) / pow(timeInAir, 2.0)
var timeInAir : float:
	get: return jumpDistance / maxMoveSpeed

enum STATES{
	IDLE,
	WALK,
	DEAD
}
var curState : STATES = STATES.IDLE

var walkTimer : float = 0.0
func walk(duration : float):
	walkTimer = duration

func _process(_delta: float) -> void:
	match curState:
		STATES.IDLE:
			#look at player
			if is_instance_valid(PlayerStats.player):
				if PlayerStats.player.global_position.x < global_position.x:
					%PlayerSprite.flip_h = true
				else:
					%PlayerSprite.flip_h = false
			
			$AnimationPlayer.play("Idle")
			return
		STATES.WALK:
			align()
			$AnimationPlayer.play("Walk")
			return
		STATES.DEAD:
			pass

var walkVelocity := Vector2.ZERO
var jumpVelocity := Vector2.ZERO
var xInput : float = 0.0
func _physics_process(delta: float) -> void:
	if walkTimer > 0.0:
		walkTimer -= delta
		xInput = 1.0
		curState = STATES.WALK
	else:
		xInput = 0.0
		curState = STATES.IDLE
	
	if is_on_ceiling():
		if jumpVelocity.y < 0.0:
			jumpVelocity.y = 0.0
	
	walkVelocity.x = xInput * maxMoveSpeed * delta * 60.0 * PlayerStats.maxMoveSpeedMultiplier
	if TerrainRendering.isPositionLoaded(global_position):
		jumpVelocity.y += delta * g * PlayerStats.gravityMultiplier
	if is_on_floor() and jumpVelocity.y > 0.0:
		jumpVelocity.y = 0.0
	
	velocity = walkVelocity + jumpVelocity
	
	if !%BumpRaycast.is_colliding() and is_on_wall() and velocity.y >= 0.0:
		position.y -= 2.0 * -up_direction.y
	
	move_and_slide()

func align():
	if velocity.x > 0.0:
		%PlayerSprite.flip_h = false
		%BumpRaycast.scale.x = 1.0
	if velocity.x < 0.0:
		%PlayerSprite.flip_h = true
		%BumpRaycast.scale.x = -1.0


var dead : bool = false
func die():
	if !dead:
		$StateMachine.switchStates("Stun")
		
		%PlayerSprite.visible = false
		$ParticleEffects/DeathParticles.emitting = true
		$AnimationPlayer.stop()
		
		dead = true
		$Sounds/Death.play()
