extends Sprite2D

@export var dialogLayer : CanvasLayer
@export var dialogBox : DialogBox
@export var sound : AudioStreamPlayer
@export var level : TutorialLevel

@export var type : DialogResource.ICONS

var t : float = 0.0
var targetRoation : float = 0.0

func _process(delta: float) -> void:
	if dialogBox.readyToProceed() or !level.inDialog:
		rotation = 0.0
		return
	if !level.curDialog:
		return
	if level.curDialog.icon != type:
		return
	if dialogLayer.visible == false:
		return
		
	
	t -= delta
	if t <= 0.0:
		targetRoation = randf_range(0.1, 0.3)
		targetRoation *= -1.0 if randi_range(0, 1) == 0 else 1.0
		sound.play()
		t = randf_range(0.05, 0.05)
	
	rotation = lerp_angle(rotation, targetRoation, 20.0 * delta)
