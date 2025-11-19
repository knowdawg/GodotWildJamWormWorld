extends PointLight2D
class_name OnScreenPointLight

var canBeVisible : bool = false
var targetVisibility : bool

func _ready() -> void:
	targetVisibility = visible

func _process(_delta: float) -> void:
	if is_instance_valid(Game.camera):
		var camPos := Game.camera.global_position
		if global_position.distance_to(camPos) > 300.0:
			canBeVisible = false
		else:
			canBeVisible = true
	
	if !targetVisibility:
		visible = false
	
	if !canBeVisible:
		visible = false
	
	if canBeVisible and targetVisibility:
		visible = true
