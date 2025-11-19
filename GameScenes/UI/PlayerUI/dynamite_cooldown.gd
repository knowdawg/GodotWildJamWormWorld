extends HBoxContainer


var t : float = 0.0

func _process(delta: float) -> void:
	%DynamiteCount.text = str(PlayerStats.dynamiteCount)
	
	if PlayerStats.dynamiteFull:
		%DynamiteProgress.value = 100.0
		return
	
	if get_tree().paused:
		return
	
	t += delta
	if t >= PlayerStats.dynamiteRecoverySpeed:
		t -= PlayerStats.dynamiteRecoverySpeed
		PlayerStats.dynamiteCount += 1
	%DynamiteProgress.value = (t / PlayerStats.dynamiteRecoverySpeed) * 100.0
	
