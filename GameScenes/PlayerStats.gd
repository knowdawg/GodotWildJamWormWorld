extends Node

var player : Player

#Player Stats
var jumpForceMultiplier : float
var maxMoveSpeedMultiplier : float
var gravityMultiplier : float

var maxFlightTime : float
var flightPower : float
var maxFlightSpeed : float


var playerGlowScale : float
var playerGlowEnergy : float

var playerFlashLighScale : float
var playerFlashLighEnergy : float

#Picaxe
var picaxeUseSpeed : float
var picaxeRadius : int

#Dynamite
var dynamiteExplosionSpeedScale : float
var dynamiteExplosionRadius : float
var dynamiteRecoverySpeed : float
var dynamiteMaxCount : int

#Flares
var flareTime : float
var flareRecoverySpeed : float
var flareMaxCount : int
var flareTextureScale : float
var flareLightEnergy : float

#Resource Count
var dynamiteCount : int
var flareCount : int
var flightLeft : float


func resetPlayerStats():
	#Player Stats
	jumpForceMultiplier = 1.0
	maxMoveSpeedMultiplier = 1.0
	gravityMultiplier = 1.0

	maxFlightTime = 0.5
	flightPower = 1500.0
	maxFlightSpeed = 100.0


	playerGlowScale = 0.5
	playerGlowEnergy = 0.5

	playerFlashLighScale = 0.5
	playerFlashLighEnergy = 0.5

	#Picaxe
	picaxeUseSpeed = 0.35
	picaxeRadius = 9

	#Dynamite
	dynamiteExplosionSpeedScale = 1.0
	dynamiteExplosionRadius = 48
	dynamiteRecoverySpeed = 30.0
	dynamiteMaxCount = 1

	#Flares
	flareTime = 5.0
	flareRecoverySpeed = 3.0
	flareMaxCount = 3
	flareTextureScale = 1.0
	flareLightEnergy = 2.0

	#Resource Count
	dynamiteCount = 1
	flareCount = 3
	flightLeft = 0.0


func _ready() -> void:
	Game.mapGenerated.connect(resetPlayerStats)

var flareFull : bool :
	get : return flareCount == flareMaxCount
var dynamiteFull : bool :
	get : return dynamiteCount == dynamiteMaxCount


func useDynamite() -> bool:
	if dynamiteCount > 0:
		dynamiteCount -= 1
		return true
	else:
		return false

func useFlare() -> bool:
	if flareCount > 0:
		flareCount -= 1
		return true
	else:
		return false
