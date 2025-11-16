extends Node

var terrainNoise : NoiseTexture2D = preload("res://RandomMapGenerator/Noises/TerrainNoiseTexture.tres")
var backgroundNoise : NoiseTexture2D = preload("res://RandomMapGenerator/Noises/BackgroundNoiseTexture.tres")
var fuelNoise : NoiseTexture2D = preload("res://RandomMapGenerator/Noises/FuelNoiseTexture.tres")

var torch = preload("res://GameScenes/Torch/torch.tscn")

func _ready() -> void:
	terrainNoise.width = TerrainRendering.mapSize.x
	terrainNoise.height = TerrainRendering.mapSize.y
	
	backgroundNoise.width = TerrainRendering.mapSize.x
	backgroundNoise.height = TerrainRendering.mapSize.y
	
	fuelNoise.width = TerrainRendering.mapSize.x
	fuelNoise.height = TerrainRendering.mapSize.y
	
	call_deferred("createWorld")


func createWorld():
	var fuelIm : Image = fuelNoise.get_image()
	fuelIm.convert(TerrainRendering.IMAGE_FORMAT)
	
	
	var terrainIm : Image = terrainNoise.get_image()
	terrainIm.convert(TerrainRendering.IMAGE_FORMAT)
	terrainIm.blend_rect(fuelIm, fuelIm.get_used_rect(), Vector2i.ZERO)
	TerrainRendering.imageForeground = terrainIm
	
	var backIm : Image = backgroundNoise.get_image()
	backIm.convert(TerrainRendering.IMAGE_FORMAT)
	TerrainRendering.imageBackground = backIm
	
	Game.mapGenerated.emit()
	
	#generate random torches
	randomize()
	for i in range(200):
		var torchPos = Vector2i(randi_range(0, TerrainRendering.mapSize.x), randi_range(0, TerrainRendering.mapSize.y))
		if TerrainRendering.getPixel(torchPos, TerrainRendering.LAYER_TYPE.FOREGROUND) == -1:
			var t : Node2D = torch.instantiate()
			Game.addProjectile(t)
			t.global_position = torchPos
