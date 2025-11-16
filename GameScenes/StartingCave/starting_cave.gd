extends Node2D

var caveBlueprint : Blueprint = preload("res://RandomMapGenerator/Blueprints/bp_cave.tres")
var player = preload("res://Player/player.tscn")

func _ready() -> void:
	#Starting cave is the bottom center of the map
	global_position.x = float(TerrainRendering.mapSize.x) / 2.0
	global_position.y = float(TerrainRendering.mapSize.y) - 200.0
	
	Game.mapGenerated.connect(createStartingCave)

func createStartingCave():
	print("creating Cave")
	TerrainDestruction.addTileImage(global_position, caveBlueprint.imageForground, TerrainRendering.LAYER_TYPE.FOREGROUND, false)
	#TerrainDestruction.addTileImage(global_position, caveBlueprint.imageBackground, TerrainRendering.LAYER_TYPE.BACKGROUND, false)
	print("Finished Cave")
	
	var p : Player = player.instantiate()
	add_child(p)
	p.global_position = global_position
