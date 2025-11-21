extends Level


func _ready() -> void:
	Game.inTutorial = true
	super._ready()
	PlayerStats.resetPlayerStats()


func createDialog():
	pass
