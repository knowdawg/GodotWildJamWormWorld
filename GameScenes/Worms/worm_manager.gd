extends Node2D
class_name WormManager

var worm : PackedScene = preload("res://GameScenes/Worms/worm.tscn")
var worms : Array[Worm]

func _ready() -> void:
	$Sprite2D.visible = true
	for i in range(20):
		var w : Worm = worm.instantiate()
		w.manager = self
		worms.append(w)
		add_child(w)

func _process(_delta: float) -> void:
	if Game.camera:
		$Sprite2D.global_position = Vector2(Game.camera.global_position.x, Game.wormHight)

func getNewPosition() -> Vector2:
	if !Game.camera:
		return Vector2.ZERO
	
	var cameraPos : Vector2 = Game.camera.global_position
	
	var wormSpawnPos = Vector2(cameraPos.x + randf_range(-400.0, 400.0), Game.wormHight)
	
	return wormSpawnPos
