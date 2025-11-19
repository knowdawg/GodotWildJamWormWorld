extends PointLight2D


func _process(_delta: float) -> void:
	texture_scale = PlayerStats.playerFlashLighScale
	energy = PlayerStats.playerFlashLighEnergy
	
	rotation = (global_position - get_global_mouse_position()).normalized().angle() + PI
