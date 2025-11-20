extends Node2D
class_name WormManager

var worm : PackedScene = preload("res://GameScenes/Worms/worm.tscn")
var worms : Array[Worm]

func _ready() -> void:
	$Sprite2D.visible = true
	for i in range(40):
		var w : Worm = worm.instantiate()
		w.manager = self
		worms.append(w)
		add_child(w)
	
	
	$RockNoises/WormRocksAmbience1.play()
	await get_tree().create_timer(1).timeout
	$RockNoises/WormRocksAmbience2.play()
	await get_tree().create_timer(1).timeout
	$RockNoises/WormRocksAmbience3.play()

func _process(_delta: float) -> void:
	
	if Game.camera:
		$Sprite2D.global_position = Vector2(Game.camera.global_position.x, Game.wormHight)
		$WormParticles.global_position = Vector2(Game.camera.global_position.x, Game.wormHight) + Vector2(0.0, 50.0)
		$WormAmbience.position = Vector2(Game.camera.global_position.x, Game.wormHight)
		$RockNoises.position = Vector2(Game.camera.global_position.x, Game.wormHight)
		
		if is_instance_valid(PlayerStats.player):
			var shake : float = 150.0 - clamp(abs(PlayerStats.player.global_position.y - Game.wormHight), 0.0, 150.0)
			Game.camera.setMinimumShake(shake * 0.004)
			

func getNewPosition() -> Vector2:
	if !Game.camera:
		return Vector2.ZERO
	
	var cameraPos : Vector2 = Game.camera.global_position
	
	var wormSpawnPos = Vector2(cameraPos.x + randf_range(-400.0, 400.0), Game.wormHight)
	
	return wormSpawnPos
