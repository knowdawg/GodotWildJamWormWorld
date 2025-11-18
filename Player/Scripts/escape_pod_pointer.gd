extends Sprite2D

@export var player : Player
@export var maxDistance : float = 75.0

func _process(_delta: float) -> void:
	if is_instance_valid(Game.escapePod):
		visible = true
		var dir : Vector2 = (Game.escapePod.global_position - player.global_position + Vector2(0.0, 10.0)).normalized()
		position = dir * maxDistance
		rotation = dir.angle()
	else:
		visible = false
