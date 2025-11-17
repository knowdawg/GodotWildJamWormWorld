extends Node

signal mapGenerated

var gameManager : GameManager

var amountOfFuel : int = 0
var flightPercentage : float = 0.0

var camera : GameCamera




func addProjectile(p):
	gameManager.addProjectile(p)
