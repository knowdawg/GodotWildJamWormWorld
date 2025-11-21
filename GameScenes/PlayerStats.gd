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


var bombBootsRadius : int

var blastProof : bool
var chestSence : bool
var canMove : bool
var reverseGravity : bool

#Picaxe
var picaxeUseSpeed : float
var picaxeRadius : int
var canUsePick : bool

#Dynamite
var dynamiteExplosionSpeedScale : float
var dynamiteExplosionRadius : int
var dynamiteRecoverySpeed : float
var dynamiteMaxCount : int
var infinateTNT : bool
var balloon : bool
var stickyDynamite : bool

#Flares
var flareTime : float
var flareRecoverySpeed : float
var flareMaxCount : int
var flareTextureScale : float
var flareLightEnergy : float
var lantern : bool
var flareExplosionRadius : int
var shotgunFlares : int
var heavyFlares : bool

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
	
	bombBootsRadius = 0
	
	blastProof = false
	chestSence = false
	canMove = true
	reverseGravity = false

	#Picaxe
	picaxeUseSpeed = 0.45
	picaxeRadius = 9
	canUsePick = true

	#Dynamite
	dynamiteExplosionSpeedScale = 1.0
	dynamiteExplosionRadius = 64
	dynamiteRecoverySpeed = 20.0
	dynamiteMaxCount = 1
	infinateTNT = false
	balloon = false
	stickyDynamite = false

	#Flares
	flareTime = 5.0
	flareRecoverySpeed = 5.0
	flareMaxCount = 3
	flareTextureScale = 0.5
	flareLightEnergy = 1.0
	lantern = false
	flareExplosionRadius = 0
	shotgunFlares = 0
	heavyFlares = false

	#Resource Count
	dynamiteCount = 1
	flareCount = 3
	flightLeft = 0.0


func _process(_delta: float) -> void:
	if infinateTNT:
		dynamiteCount = dynamiteMaxCount
	
	canUsePick = true
	gravityMultiplier = max(gravityMultiplier, 0.1)
	playerGlowScale = max(playerGlowScale, 0.1)
	playerGlowEnergy = max(playerGlowEnergy, 0.1)
	playerFlashLighScale = max(playerFlashLighScale, 0.1)
	playerFlashLighEnergy = max(playerFlashLighEnergy, 0.1)
	picaxeUseSpeed = max(picaxeUseSpeed, 0.05)
	picaxeRadius = max(picaxeRadius, 5)
	dynamiteExplosionSpeedScale = max(dynamiteExplosionSpeedScale, 0.1)
	dynamiteExplosionRadius = max(dynamiteExplosionRadius, 1)
	dynamiteRecoverySpeed = max(dynamiteRecoverySpeed, 0.1)
	flareTime = max(flareTime, 0.1)
	flareRecoverySpeed = max(flareRecoverySpeed, 0.1)
	flareTextureScale = max(flareTextureScale, 0.1)
	flareLightEnergy = max(flareLightEnergy, 0.1)



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
