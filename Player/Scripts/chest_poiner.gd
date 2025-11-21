extends Sprite2D

func _process(delta: float) -> void:
	if !PlayerStats.chestSence:
		visible = false
		return
		
	visible = true
	
	var nearest : UpgradeChest
	var nearestDis : float = 9999999999.9
	for c : UpgradeChest in Game.chest:
		if !is_instance_valid(c):
			continue
		
		var dis = global_position.distance_to(c.global_position)
		if dis < nearestDis:
			nearest = c
			nearestDis = dis
	
	var targetDir = (nearest.global_position - global_position).angle()
	rotation = lerp_angle(rotation, targetDir, delta * 10.0)
