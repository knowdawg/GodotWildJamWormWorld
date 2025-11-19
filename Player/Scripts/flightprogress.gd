extends ProgressBar

func _process(_delta: float) -> void:
	
	value = (PlayerStats.flightLeft / PlayerStats.maxFlightTime) * 100.0
	
	if value >= 99.8:
		visible = false
	else:
		visible = true
