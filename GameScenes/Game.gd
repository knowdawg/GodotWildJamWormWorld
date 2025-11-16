extends Node

var gameManager : GameManager

var amountOfFuel : int = 0

signal mapGenerated

func addProjectile(p):
	gameManager.addProjectile(p)
