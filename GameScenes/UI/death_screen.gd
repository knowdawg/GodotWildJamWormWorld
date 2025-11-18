extends CanvasLayer
class_name DeathScreenUI

var mainGame : String = "uid://c5lmuy85ljtkk"
var mainMenu : String = "uid://1ptq38jqhvir"

var noMoreInput : bool = false

func _ready() -> void:
	Game.playerDead.connect(animate)

func animate():
	await get_tree().create_timer(2.0).timeout
	$AnimationPlayer.play("Splat")

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
