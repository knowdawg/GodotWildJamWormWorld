extends Node2D
class_name WormManager

var worm : PackedScene = preload("res://GameScenes/Worms/worm.tscn")
var worms : Array[Worm]


var wormTravelSpeed : float = 15.0
var wormTravelSpeedMultiplier : float = 0.0

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
	
	
	await  get_tree().create_timer(10).timeout
	startMoving()

func _process(delta: float) -> void:
	updateWormSpeed()
	Game.wormHight -= wormTravelSpeed * delta * wormTravelSpeedMultiplier
	
	print(Game.wormHight)
	
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

func startMoving():
	wormTravelSpeedMultiplier = 1.0
	Game.wormsStartingToMove.emit()

func updateWormSpeed() -> void:
	if Game.wormHight < float(TerrainRendering.mapSize.y) * 0.25:
		if wormTravelSpeedMultiplier != 3.0:
			wormTravelSpeedMultiplier = 3.0
			Game.wormsSpeedingUp.emit(wormTravelSpeedMultiplier)
		return
	if Game.wormHight < float(TerrainRendering.mapSize.y) * 0.5:
		if wormTravelSpeedMultiplier != 2.25:
			wormTravelSpeedMultiplier = 2.25
			Game.wormsSpeedingUp.emit(wormTravelSpeedMultiplier)
		return
	if Game.wormHight < float(TerrainRendering.mapSize.y) * 0.75:
		if wormTravelSpeedMultiplier != 1.5:
			wormTravelSpeedMultiplier = 1.5
			Game.wormsSpeedingUp.emit(wormTravelSpeedMultiplier)
		return
	
	#wormTravelSpeedMultiplier = 1.0
