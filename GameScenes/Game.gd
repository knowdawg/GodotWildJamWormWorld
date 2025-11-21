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
var amoundOfFuelNeeded : int = 2000.0

var camera : GameCamera
var escapePod : EscapePod
var wormHight : float = 0.0


var chest : Array[UpgradeChest]

func _ready() -> void:
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
