extends Camera2D
class_name GameCamera

func _ready() -> void:
	Game.camera = self


var screenShake : float = 0.0


func setMinimumShake(shake : float):
	if Game.screenShake:
		if shake > screenShake:
			screenShake = shake


func _process(delta: float) -> void:
	if is_current():
		Game.camera = self
	
	screenShake = lerp(screenShake, 0.0, delta * 5.0)
	
	offset = Vector2(randf_range(-screenShake, screenShake), randf_range(-screenShake, screenShake))
	
	if is_instance_valid(PlayerStats.player):
		if PlayerStats.player.inEscapePod:
			return
	
	limit_bottom = min(int(Game.wormHight + 40.0), TerrainRendering.mapSize.y)
	
