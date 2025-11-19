extends Panel
class_name UpgradeCard

var playerUI : PlayerUI
@export var upgrade : UpgradeResource

func _on_mouse_entered() -> void:
	playerUI.cardFocus(%UpgradeIcon.texture, %Label.text)

func _on_mouse_exited() -> void:
	playerUI.cardUnFocused()


func setup() -> void:
	%Label.text = upgrade.text
	%UpgradeIcon.texture = upgrade.tex
	
	for k : String in upgrade.playerStatsPropertyChanges.keys():
		var value : Variant = upgrade.playerStatsPropertyChanges[k]
		
		
		#print(PlayerStats.get_property_list())
		
		PlayerStats.set(k, PlayerStats.get(k) + value)
