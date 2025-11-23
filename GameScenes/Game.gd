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


var fuelSoundPlayer : AudioStreamPlayer
var fuelSoundTime : float = 0.0
var fuelSoundCooldown : float = 0.0

var fuelAudio : AudioStreamRandomizer = preload("res://Sounds/FuelRandomAudio.tres")
func _process(delta: float) -> void:
	if fuelSoundTime > 0:
		fuelSoundTime -= delta
		fuelSoundCooldown -= delta
		if fuelSoundCooldown <= 0.0:
			fuelSoundCooldown = randf_range(0.05, 0.1)
			fuelSoundPlayer.play()


var amountOfFuel : int = 0:
	set(amount):
		if amount > 0 and amount > amountOfFuel:
			fuelSoundTime += float(amount - amountOfFuel) * 0.003
		amountOfFuel = amount
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
	
	fuelSoundPlayer = AudioStreamPlayer.new()
	fuelSoundPlayer.bus = "SoundEffects"
	fuelSoundPlayer.stream = fuelAudio
	add_child(fuelSoundPlayer)

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
