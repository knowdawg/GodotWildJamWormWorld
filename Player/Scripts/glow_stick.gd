extends RigidBody2D
class_name Glowstick

var duration : float = 20.0

func _ready() -> void:
	$AnimationPlayer.speed_scale = 1.0 / duration
	$AnimationPlayer.play("Glow")

func setup(direciton : Vector2, force : float):
	apply_central_impulse(direciton * force)
	rotation = randf()
	inertia = 1.0
	apply_torque_impulse(randf_range(-30.0, 30.0))

#func _physics_process(_delta: float) -> void:
	#if get_contact_count() > 0:
		#linear_velocity = Vector2.ZERO
		#gravity_scale = 0.0
	#else:
		#gravity_scale = 0.5


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	$PointLight2D.visible = false
