extends Node2D
class_name EscapePod

var escpaePodBlueprint : Blueprint = preload("uid://byqsjo3d5j2km")

@export var lights : Array[PointLight2D] = []


enum STATES {
	DISABLED,
	CHARGING,
	READY,
	TAKEOFF
}
var state : int = STATES.DISABLED

func _ready() -> void:
	$Label.visible = false
	#escape pod is at the bottom top
	global_position.x = (float(TerrainRendering.mapSize.x) / 2.0) + 100.0
	global_position.y =  float(TerrainRendering.mapSize.y) - 200.0#500.0
	
	Game.mapGenerated.connect(createEscapePod)

func createEscapePod():
	print("creating Escape Pod")
	TerrainDestruction.addTileImage(global_position, escpaePodBlueprint.imageForground, TerrainRendering.LAYER_TYPE.FOREGROUND, false)
	print("Finished Escape Pod")

var t : float = 0.0
func _process(delta: float) -> void:
	t += delta
	%Label.visible = false
	
	match state:
		STATES.DISABLED:
			updateLights()
			updateLabelVisibility()
			
			if Input.is_action_just_pressed("Interact") and $ProximityArea.is_player_inside():
				$AnimationPlayer.play("Spin")
				state = STATES.CHARGING
			return
		
		STATES.CHARGING:
			updateLights()
			return
		
		STATES.READY:
			updateLights()
			updateLabelVisibility()
			
			if Input.is_action_just_pressed("Interact") and $ProximityArea.is_player_inside():
				$AnimationPlayer.play("Takeoff")
				state = STATES.TAKEOFF
				Game.escapePodEntered.emit()
			return
		
		STATES.TAKEOFF:
			return
			
	


func updateLights():
	for i in range(lights.size()):
		lights[i].energy = 1.0 + (sin(t + i) * 0.3)

func updateLabelVisibility():
	if %ProximityArea.playerInside:
		%Label.visible = true
	else:
		%Label.visible = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Spin":
		$Label.text = "[center] Enter"
		state = STATES.READY
	if anim_name == "Takeoff":
		Game.escapePodFinished.emit()
