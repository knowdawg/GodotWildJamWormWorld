extends Node
class_name GameManager

@export var projectileParent : Node2D

func _ready() -> void:
	Game.gameManager = self

func addProjectile(p):
	projectileParent.add_child(p)
