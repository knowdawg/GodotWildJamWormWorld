extends Panel
class_name UpgradeCard

var playerUI : PlayerUI

func _on_mouse_entered() -> void:
	playerUI.cardFocus(%UpgradeIcon.texture, %Label.text)

func _on_mouse_exited() -> void:
	playerUI.cardUnFocused()
