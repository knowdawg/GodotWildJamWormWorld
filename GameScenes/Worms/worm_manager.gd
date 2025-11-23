extends Node2D
class_name WormManager

var worm : PackedScene = preload("uid://cpk55ujp27tih")
var worms : Array[Worm]


var wormTravelSpeed : float = 15.0
var wormTravelSpeedMultiplier : float = 0.0
var wormTargetSppedMultiplier : float = 1.5

var trueWormHight : float

var targetWormHight : float

func _ready() -> void:
	trueWormHight = TerrainRendering.mapSize.y
	targetWormHight = TerrainRendering.mapSize.y
	$Sprite2D.visible = true
	var numOfWorms : int = 40
	if Game.performanceMode:
		numOfWorms = 10
	for i in range(numOfWorms):
		var w : Worm = worm.instantiate()
		w.manager = self
		worms.append(w)
		add_child(w)
	
	$WormChaseMusic.volume_linear = 0.01
	create_tween().tween_property($WormChaseMusic, "volume_linear", 1.0, 5.0)
	$WormChaseMusic.play()
	
	$RockNoises/WormRocksAmbience1.play()
	await get_tree().create_timer(1).timeout
	$RockNoises/WormRocksAmbience2.play()
	await get_tree().create_timer(1).timeout
	$RockNoises/WormRocksAmbience3.play()
	
	
	await  get_tree().create_timer(10).timeout
	startMoving()

func _process(delta: float) -> void:
	updateWormSpeed()
	trueWormHight -= wormTravelSpeed * delta * wormTravelSpeedMultiplier
	if is_instance_valid(PlayerStats.player):
		#var pHight = PlayerStats.player.global_position.y + 100.0
		if abs(PlayerStats.player.global_position.y - Game.wormHight) > 125.0:
			targetWormHight -= wormTravelSpeed * delta * wormTravelSpeedMultiplier * wormTargetSppedMultiplier
		else:
			targetWormHight -= wormTravelSpeed * delta * wormTravelSpeedMultiplier * 0.25
		
		if is_instance_valid(Game.escapePod):
			targetWormHight = clamp(targetWormHight, Game.escapePod.global_position.y + 200.0, trueWormHight)
	
	Game.wormHight = min(trueWormHight, targetWormHight)
	
	if Game.camera:
		$Sprite2D.global_position = Vector2(Game.camera.global_position.x, Game.wormHight)
		$WormParticles.global_position = Vector2(Game.camera.global_position.x, Game.wormHight) + Vector2(0.0, 50.0)
		$WormAmbience.position = Vector2(Game.camera.global_position.x, Game.wormHight)
		$RockNoises.position = Vector2(Game.camera.global_position.x, Game.wormHight)
		
		if is_instance_valid(PlayerStats.player):
			var shake : float = 150.0 - clamp(abs(PlayerStats.player.global_position.y - Game.wormHight), 0.0, 150.0)
			Game.camera.setMinimumShake(shake * 0.004)
		
		
		#1 when right next to worms, 0 when far away
		var perc : float = 1.0 - (clamp(abs(Game.wormHight - Game.camera.global_position.y), 0.0, 500.0) / 500.0)
		if perc > 0.75:
			perc = 1.0
		var reverb : AudioEffectReverb = AudioServer.get_bus_effect(1, 0) as AudioEffectReverb
		reverb.wet = 0.5 * (1.0 - perc)
		reverb.dry = 0.5 + (0.5 * perc)
		
		var lowPass : AudioEffectLowPassFilter = AudioServer.get_bus_effect(1, 1) as AudioEffectLowPassFilter
		lowPass.cutoff_hz = 200.0 + (6000.0 * perc)
		
		#print("dry: ", reverb.dry)
		#print("wet: ", reverb.wet)
		#print("cutoff: ", lowPass.cutoff_hz)
	

func getNewPosition() -> Vector2:
	if !Game.camera:
		return Vector2.ZERO
	
	var cameraPos : Vector2 = Game.camera.global_position
	
	var wormSpawnPos = Vector2(cameraPos.x + randf_range(-400.0, 400.0), Game.wormHight + (wormTravelSpeed * wormTravelSpeedMultiplier * -1.0))
	
	return wormSpawnPos

func startMoving():
	wormTravelSpeedMultiplier = 1.0
	Game.wormsStartingToMove.emit()

func updateWormSpeed() -> void:
	if trueWormHight < float(TerrainRendering.mapSize.y) * 0.3:
		if wormTravelSpeedMultiplier != 2.3:
			wormTravelSpeedMultiplier = 2.3
			Game.wormsSpeedingUp.emit(wormTravelSpeedMultiplier)
		return
	if trueWormHight < float(TerrainRendering.mapSize.y) * 0.6:
		if wormTravelSpeedMultiplier != 1.6:
			wormTravelSpeedMultiplier = 1.6
			Game.wormsSpeedingUp.emit(wormTravelSpeedMultiplier)
		return
	if trueWormHight < float(TerrainRendering.mapSize.y) * 0.85:
		if wormTravelSpeedMultiplier != 1.3:
			wormTravelSpeedMultiplier = 1.3
			Game.wormsSpeedingUp.emit(wormTravelSpeedMultiplier)
		return
	
	#wormTravelSpeedMultiplier = 1.0
