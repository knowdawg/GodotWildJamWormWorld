extends Node2D

@export_file("*.tscn") var uiScenes : Array[String]

func _ready() -> void:
	call_deferred("addUI")

func addUI():
	for u in uiScenes:
		Game.gameManager.addUI(u, u)
