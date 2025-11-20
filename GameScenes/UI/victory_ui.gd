extends CanvasLayer
class_name VictoryUI

var mainGame : String = "uid://c5lmuy85ljtkk"
var mainMenu : String = "uid://1ptq38jqhvir"

var noMoreInput : bool = false

func _on_play_pressed() -> void:
	$PlayButtonPressed.play()
	if noMoreInput:
		return
	noMoreInput = true
	
	Game.gameManager.switchScene(mainGame, 1.0, true)


func _on_menu_pressed() -> void:
	$ButtonPressed.play()
	if noMoreInput:
		return
	noMoreInput = true
	
	Game.gameManager.switchScene(mainMenu, 1.0, true)


func _on_quit_pressed() -> void:
	$ButtonPressed.play()
	get_tree().quit()


func _on_play_mouse_entered() -> void:
	$ButtonHover.play()

func _on_menu_mouse_entered() -> void:
	$ButtonHover.play()

func _on_quit_mouse_entered() -> void:
	$ButtonHover.play()
