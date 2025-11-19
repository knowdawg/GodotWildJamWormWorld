extends Panel
class_name UpgradeCard

var playerUI : PlayerUI
var upgrade : UpgradeResource

func _on_mouse_entered() -> void:
	playerUI.cardFocus(%UpgradeIcon.texture, %Label.text)

func _on_mouse_exited() -> void:
	playerUI.cardUnFocused()


func setup() -> void:
	if !upgrade:
		return
	
	%Label.text = upgrade.text
	%UpgradeIcon.texture = upgrade.tex
	
	for k : String in upgrade.playerStatsPropertyChanges.keys():
		var value : Variant = upgrade.playerStatsPropertyChanges[k]
		
		PlayerStats.set(k, PlayerStats.get(k) + value)
	
	$SelectParticles.emitting = true
