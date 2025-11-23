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
	Game.escapePod = self
	$Label.visible = false
	#escape pod is at the bottom top
	global_position.x = (float(TerrainRendering.mapSize.x) / 2.0) + 500.0
	global_position.y =  500.0#float(TerrainRendering.mapSize.y) - 200.0#500.0
	
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
			
			if Game.amountOfFuel >= Game.amoundOfFuelNeeded:
				%Label.text = "[center](E) : Insert Fuel"
			else:
				%Label.text = "[center]Find More Fuel"
			
			if !is_instance_valid(PlayerStats.player):
				return
			if PlayerStats.player.dead == false and Input.is_action_just_pressed("Interact") and $ProximityArea.is_player_inside() and Game.amountOfFuel >= Game.amoundOfFuelNeeded:
				$AnimationPlayer.play("Spin")
				state = STATES.CHARGING
			return
		
		STATES.CHARGING:
			updateLights()
			return
		
		STATES.READY:
			updateLights()
			updateLabelVisibility()
			
			if !is_instance_valid(PlayerStats.player):
				return
			if PlayerStats.player.dead == false and Input.is_action_just_pressed("Interact") and $ProximityArea.is_player_inside():
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

var victory : String = "uid://bbsynlfnh6nhx"
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Spin":
		$Label.text = "[center](E) : Enter"
		state = STATES.READY
	if anim_name == "Takeoff":
		Game.escapePodFinished.emit()
		Game.gameManager.switchScene(victory, 4.0, true)
