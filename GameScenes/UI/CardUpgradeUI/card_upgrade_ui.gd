extends CanvasLayer
class_name CardUpgradeUI


func _ready() -> void:
	$AnimationPlayer.play("ShowCards")

func cardPicked(card : CardOption):
	pass
