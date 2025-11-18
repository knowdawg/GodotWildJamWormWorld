extends Node
class_name GameManager

@export var projectileParent : Node2D

func _ready() -> void:
	Game.gameManager = self

func addProjectile(p):
	projectileParent.add_child(p)

func switchScene(scenePath : String, fadeTime : float, clearUI : bool = true) -> void:
	
	var t : Tween = create_tween()
	t.tween_property(%DarknessRect, "modulate", Color(0.0, 0.0, 0.0, 1.0), fadeTime)
	
	await get_tree().create_timer(fadeTime).timeout#t.finished
	
	if clearUI:
		clearAllUI()
	for c in %World2D.get_children():
		c.queue_free()
		
	%World2D.add_child(load(scenePath).instantiate())
	t = create_tween()
	t.tween_property(%DarknessRect, "modulate", Color(0.0, 0.0, 0.0, 0.0), fadeTime)

func addUI(scenePath : String, uiName : String):
	var ui : Node = load(scenePath).instantiate()
	ui.name = uiName
	%UI.add_child(ui)

func removeUI(uiName : String):
	for c in %UI.get_children():
		if c.name == uiName:
			c.queue_free()
		

func clearAllUI():
	for c in %UI.get_children():
		c.queue_free()
