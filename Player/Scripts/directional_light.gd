extends PointLight2D


func _process(_delta: float) -> void:
	rotation = (global_position - get_global_mouse_position()).normalized().angle() + PI
