extends CanvasLayer
class_name PauseMenuUI

var mainMenu  : String = "uid://bdyt18qrq6ne1"


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Menu"):
		switchVisibilty()

func _on_menu_button_pressed() -> void:
	$ButtonPressed.play()
	switchVisibilty()
	Game.gameManager.switchScene(mainMenu, 1.0, true)

func _on_exit_button_pressed() -> void:
	$ButtonPressed.play()
	get_tree().quit()


func _on_settings_exit_pressed() -> void:
	$ButtonPressed.play()
	switchVisibilty()

func _on_resume_button_pressed() -> void:
	$ButtonPressed.play()
	switchVisibilty()

func switchVisibilty():
	visible = !visible
	if visible:
		Game.pauseGame()
		$PauseMenuShow.play()
	else:
		Game.resumeGame()




func _on_resume_button_mouse_entered() -> void:
	$ButtonHover.play()

func _on_menu_button_mouse_entered() -> void:
	$ButtonHover.play()

func _on_exit_button_mouse_entered() -> void:
	$ButtonHover.play()
