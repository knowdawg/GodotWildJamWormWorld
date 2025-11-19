extends PointLight2D

func _process(_delta: float) -> void:
	texture_scale = PlayerStats.playerGlowScale
	energy = PlayerStats.playerGlowEnergy
