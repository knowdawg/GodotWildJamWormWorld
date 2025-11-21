extends Node

var terrainNoise : NoiseTexture2D = preload("res://RandomMapGenerator/Noises/TerrainNoiseTexture.tres")
var backgroundNoise : NoiseTexture2D = preload("res://RandomMapGenerator/Noises/BackgroundNoiseTexture.tres")
var fuelNoise : NoiseTexture2D = preload("res://RandomMapGenerator/Noises/FuelNoiseTexture.tres")

var torch = preload("res://GameScenes/Torch/torch.tscn")
var chest = preload("uid://c2lk7shvmrjj3")

func _ready() -> void:
	terrainNoise.width = TerrainRendering.mapSize.x
	terrainNoise.height = TerrainRendering.mapSize.y
	
	backgroundNoise.width = TerrainRendering.mapSize.x
	backgroundNoise.height = TerrainRendering.mapSize.y
	
	fuelNoise.width = TerrainRendering.mapSize.x
	fuelNoise.height = TerrainRendering.mapSize.y
	
	
	
	Game.generateLevel.connect(createWorld)
	#call_deferred("createWorld")


func createWorld():
	randomize()
	var tn : FastNoiseLite = terrainNoise.noise
	tn.seed = randi()
	tn = backgroundNoise.noise
	tn.seed = randi()
	tn = fuelNoise.noise
	tn.seed = randi()
	
	await get_tree().process_frame
	
	var fuelIm : Image = fuelNoise.get_image()
	fuelIm.convert(TerrainRendering.IMAGE_FORMAT)
	
	
	var terrainIm : Image = terrainNoise.get_image()
	terrainIm.convert(TerrainRendering.IMAGE_FORMAT)
	terrainIm.blend_rect(fuelIm, fuelIm.get_used_rect(), Vector2i.ZERO)
	TerrainRendering.imageForeground = terrainIm.duplicate()
	
	var backIm : Image = backgroundNoise.get_image()
	backIm.convert(TerrainRendering.IMAGE_FORMAT)
	TerrainRendering.imageBackground = backIm.duplicate()
	
	TerrainRendering.dirtyAll()
	
	Game.mapGenerated.emit()
	
	#generate random chests
	randomize()
	print("num of chests : ", TerrainRendering.mapSize.y / 10)
	for i in range(TerrainRendering.mapSize.y / 10):
		var chestPos = Vector2i(randi_range(0, TerrainRendering.mapSize.x), randi_range(0, TerrainRendering.mapSize.y))
		if TerrainRendering.getPixel(chestPos, TerrainRendering.LAYER_TYPE.FOREGROUND) == -1:
			var c : Node2D = chest.instantiate()
			Game.addProjectile(c)
			c.global_position = chestPos
	
	
