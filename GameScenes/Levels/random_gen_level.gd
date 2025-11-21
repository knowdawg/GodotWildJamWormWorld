extends Level

func _ready() -> void:
	Game.inTutorial = false
	super._ready()
	
	Game.generateLevel.emit()
	Game.startGame()
	#Game.playerDead.connect(respawnLevel)


var path : String = "uid://c5lmuy85ljtkk"
func respawnLevel():
	Game.gameManager.switchScene(path, 1.0, true)
