extends Node

signal mapGenerated
signal escapePodEntered
signal escapePodFinished

var gameManager : GameManager

var amountOfFuel : int = 0
var flightPercentage : float = 0.0

var camera : GameCamera




func addProjectile(p):
	gameManager.addProjectile(p)
