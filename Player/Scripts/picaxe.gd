extends Sprite2D

@export var player : Player

enum STATES{
	IDLE1,
	SWING1,
	IDLE2,
	SWING2
}
var state : int = STATES.IDLE1

@export_range(-PI, PI) var offsetAngle : float = 0.0

var tween : Tween

func getRotation() -> float:
	var directionToMouse : Vector2 = player.global_position - get_global_mouse_position()
	var r = directionToMouse.normalized().angle() + offsetAngle
	return r

func getDirectionVector() -> Vector2:
	var directionToMouse : Vector2 = player.global_position - get_global_mouse_position()
	return directionToMouse.normalized()

func destroyTerrain() -> void:
	var destoryedTiles := TerrainDestruction.addTileRadius(player.global_position - getDirectionVector() * 5.0, -1, PlayerStats.picaxeRadius, TerrainRendering.LAYER_TYPE.FOREGROUND)
	Game.amountOfFuel += destoryedTiles[2] #Fuel Index
	print(Game.amountOfFuel)

func _process(_delta: float) -> void:
	rotation = getRotation()
	match state:
		STATES.IDLE1:
			if Input.is_action_pressed("Use"):
				state = STATES.SWING1
				
				tween = create_tween()
				var swingFinalRotation = rotation - (PI * 2.0)
				tween.tween_property(self, "rotation", swingFinalRotation, PlayerStats.picaxeUseSpeed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
				
				destroyTerrain()
			return
			
		STATES.SWING1:
			await tween.finished
			await get_tree().create_timer(0.1).timeout
			state = STATES.IDLE2
			return
			
		STATES.IDLE2:
			if Input.is_action_pressed("Use"):
				state = STATES.SWING2
				
				tween = create_tween()
				var swingFinalRotation = rotation + (PI * 2.0)
				tween.tween_property(self, "rotation", swingFinalRotation, PlayerStats.picaxeUseSpeed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
				
				destroyTerrain()
			return
			
		STATES.SWING2:
			await tween.finished
			await get_tree().create_timer(0.1).timeout
			state = STATES.IDLE1
			return
