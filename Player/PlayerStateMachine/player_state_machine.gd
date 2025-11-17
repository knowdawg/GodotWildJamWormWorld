extends StateMachine
class_name PlayerStateMachine

@export_group("Timers")
@export var inputBufferTimer : Timer
@export var jumpBufferTimer : Timer
@export var coyoteTimer : Timer

@export_group("Raycasts")
@export var ledgeRayCollision : RayCast2D
@export var ledgeRaySpace : RayCast2D

enum INPUTS {
	NONE = -1,
	JUMP,
	BOMB,
}

var inputBuffer : int = -1

var canJump : bool = false
var jumpBuffer : bool = false

var canLedgeGrab : bool = false

var maxFlightTIme : float = 0.5
var flightTime : float = 0.0
func _process(delta):
	super._process(delta)
	
	Game.flightPercentage = (flightTime / maxFlightTIme) * 100.0
	
	var p : Player = parent as Player
	if p.is_on_floor() or current_state is PlayerLedgeGrab:
		flightTime = maxFlightTIme
		coyoteTimer.start()
		canJump = true
	
	if Input.is_action_just_pressed("Jump"):
		jumpBufferTimer.start()
		jumpBuffer = true
	
	if Input.is_action_just_pressed("Jump"):
		inputBuffer = INPUTS.JUMP
		inputBufferTimer.start()
	
	if Input.is_action_just_pressed("Bomb"):
		inputBuffer = INPUTS.BOMB
		inputBufferTimer.start()
	
	#if Input.is_action_just_pressed(""):
		#inputBuffer = INPUTS.JUMP
		#inputBufferTimer.start(0.2)

func _physics_process(delta):
	super._physics_process(delta)
	
	var p : Player = parent as Player
	
	if ledgeRayCollision.is_colliding() and !ledgeRaySpace.is_colliding() and p.velocity.y > 0: #moving down
		canLedgeGrab = true
	else:
		canLedgeGrab = false


func _on_input_buffer_timeout() -> void:
	inputBuffer = INPUTS.NONE

func _on_coyote_timer_timeout() -> void:
	canJump = false

func _on_jump_buffer_timeout() -> void:
	jumpBuffer = false
