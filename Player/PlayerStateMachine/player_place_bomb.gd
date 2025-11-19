extends State
class_name PlayerPlaceBomb

@export var anim : AnimationPlayer

var dynamite = preload("res://Player/Scenes/dynamite.tscn")


var timeInState : float = 0.5
var timeRemaining : float = 0.0

func enter(_prevState : State):
	anim.play("PlaceBomb")
	timeRemaining = timeInState

func update(delta : float):
	timeRemaining -= delta
	
	if timeRemaining <= 0.0:
		transitioned.emit(self, "Idle")
		return

func placeBomb():
	if PlayerStats.useDynamite():
		var d : Node2D = dynamite.instantiate()
		Game.addProjectile(d)
		d.global_position = parent.global_position

func update_physics(delta: float):
	var p : Player = parent as Player
	
	p.noInputPhysicsUpdate(delta)
