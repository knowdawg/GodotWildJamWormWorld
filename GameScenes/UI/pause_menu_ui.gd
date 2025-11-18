extends CanvasLayer
class_name PauseMenuUI

var mainMenu  : String = "uid://bdyt18qrq6ne1"


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Menu"):
		switchVisibilty()

func _on_menu_button_pressed() -> void:
	switchVisibilty()
	Game.gameManager.switchScene(mainMenu, 1.0, true)

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_exit_pressed() -> void:
	switchVisibilty()

func switchVisibilty():
	visible = !visible
	if visible:
		Game.pauseGame()
	else:
		Game.resumeGame()
