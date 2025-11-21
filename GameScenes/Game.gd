extends Node

signal mapGenerated
signal escapePodEntered
signal escapePodFinished
signal generateLevel
signal playerDead
signal cardPicked(upgrade :  UpgradeResource)
signal createCardUpgrade()
signal wormsSpeedingUp(newSpeed : float)
signal wormsStartingToMove()

var gameManager : GameManager

var amountOfFuel : int = 0
var amoundOfFuelNeeded : int = 3000.0

var camera : GameCamera
var escapePod : EscapePod
var wormHight : float = 0.0

var screenShake : bool = true
var performanceMode : bool = false

var chest : Array[UpgradeChest]


var inTutorial : bool = false

func _ready() -> void:
	AudioServer.set_bus_volume_linear(0, 0.6)
	wormHight = TerrainRendering.mapSize.y

func addProjectile(p):
	gameManager.addProjectile(p)

var pauseInstances : int = 0
func pauseGame():
	pauseInstances += 1
	if pauseInstances > 0:
		get_tree().paused = true

func resumeGame():
	pauseInstances -= 1
	if pauseInstances <= 0:
		get_tree().paused = false

func startGame():
	amountOfFuel = 0.0
	wormHight = TerrainRendering.mapSize.y
