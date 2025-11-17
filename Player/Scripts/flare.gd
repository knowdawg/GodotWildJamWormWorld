extends Node2D
class_name Flare

var duration : float = 20.0

var moveVec : Vector2
var initPos : Vector2

var t : float = 0.5

func _ready() -> void:
	$AnimationPlayer.speed_scale = 1.0 / duration
	$AnimationPlayer.play("Travel")
	

func setup(direciton : Vector2, force : float, origin : Vector2):
	moveVec = direciton * force
	$Sprite2D.rotation = moveVec.normalized().angle()
	initPos = origin

func _physics_process(delta: float) -> void:
	t -= delta
	
	if $Sprite2D/RayCast2D.is_colliding():
		global_position = $Sprite2D/RayCast2D.get_collision_point() - (moveVec.normalized() * 3.0)
		moveVec = Vector2.ZERO
		$AnimationPlayer.play("Glow")
		$Sprite2D/RayCast2D.set_deferred("enabled", false)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Glow":
		queue_free()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_line(initPos - position, Vector2.ZERO, Color(1.0, 0.0, 0.0, t * 2.0), t * 5.0)
