extends Camera2D
class_name GameCamera

func _ready() -> void:
	Game.camera = self


var screenShake : float = 0.0


func setMinimumShake(shake : float):
	if shake > screenShake:
		screenShake = shake


func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("Glowstick"):
		#setMinimumShake(10)
	
	screenShake = lerp(screenShake, 0.0, delta * 5.0)
	
	offset = Vector2(randf_range(-screenShake, screenShake), randf_range(-screenShake, screenShake))
