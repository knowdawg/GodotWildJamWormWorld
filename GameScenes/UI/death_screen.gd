extends CanvasLayer
class_name DeathScreenUI

var mainGame : String = "uid://c5lmuy85ljtkk"
var mainMenu : String = "uid://1ptq38jqhvir"
var tutorialLevel : String = "uid://dvk83gspj5nvl"

var noMoreInput : bool = false

func _ready() -> void:
	Game.playerDead.connect(animate)
	
	if Game.inTutorial:
		$MarginContainer/RichTextLabel.text = "[center]Dead"

func animate():
	await get_tree().create_timer(2.0).timeout
	$AnimationPlayer.play("Splat")

func _on_play_pressed() -> void:
	$PlayButtonPressed.play()
	if noMoreInput:
		return
	noMoreInput = true
	
	if Game.inTutorial:
		Game.gameManager.switchScene(tutorialLevel, 1.0, true)
	else:
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
