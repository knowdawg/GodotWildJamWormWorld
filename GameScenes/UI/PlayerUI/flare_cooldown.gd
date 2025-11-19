extends HBoxContainer

var t : float = 0.0

func _process(delta: float) -> void:
	%FlareCount.text = str(PlayerStats.flareCount)
	
	if PlayerStats.flareFull:
		%FlareProgress.value = 100.0
		return
	
	if get_tree().paused:
		return
	
	t += delta
	if t >= PlayerStats.flareRecoverySpeed:
		t -= PlayerStats.flareRecoverySpeed
		PlayerStats.flareCount += 1
	%FlareProgress.value = (t / PlayerStats.flareRecoverySpeed) * 100.0
	
