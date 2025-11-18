extends CanvasLayer
class_name VictoryUI

var mainGame : String = "uid://c5lmuy85ljtkk"
var mainMenu : String = "uid://1ptq38jqhvir"

var noMoreInput : bool = false

func _on_play_pressed() -> void:
	if noMoreInput:
		return
	noMoreInput = true
	
	Game.gameManager.switchScene(mainGame, 1.0, true)


func _on_menu_pressed() -> void:
	if noMoreInput:
		return
	noMoreInput = true
	
	Game.gameManager.switchScene(mainMenu, 1.0, true)


func _on_quit_pressed() -> void:
	get_tree().quit()
