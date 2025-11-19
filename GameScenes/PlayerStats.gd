extends Node

var player : Player

#Player Stats
var jumpForceMultiplier : float = 1.0
var maxMoveSpeedMultiplier : float = 1.0
var gravityMultiplier : float = 1.0
var maxFlightTime : float = 0.5

var playerGlowScale : float = 0.5
var playerGlowEnergy : float = 0.5

#Picaxe
var picaxeUseSpeed : float = 0.35
var picaxeRadius : int = 9

#Dynamite
var dynamiteExplosionSpeedScale : float = 1.0
var dynamitsExplosionRadius : float = 48
var dynamiteRecoverySpeed : float = 30.0
var dynamiteMaxCount : int = 1

#Flares
var flareTime : float = 5.0
var flareRecoverySpeed : float = 3.0
var flareMaxCount : int = 3
var flareTextureScale : float = 1.0
var flareLightEnergy : float = 2.0

#Resource Count
var dynamiteCount : int = 0
var flareCount : int = 0
var flightLeft : float = 0.0


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
