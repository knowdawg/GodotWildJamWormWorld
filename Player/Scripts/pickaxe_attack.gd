extends Area2D
class_name PicaxeAttack

func enable():
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = true
