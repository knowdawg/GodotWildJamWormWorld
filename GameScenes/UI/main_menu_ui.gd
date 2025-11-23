extends CanvasLayer
class_name MainMenuUI

var mainLevel : String = "uid://c5lmuy85ljtkk"
var tutorialLevel : String = "uid://dvk83gspj5nvl"

var noMoreInput : bool = false


func _process(delta: float) -> void:
	$Sprite2D.position = lerp($Sprite2D.position, $Sprite2D.get_global_mouse_position(), 10.0 * delta)

func _on_play_pressed() -> void:
	$ButtonPressed.play()
	if noMoreInput:
		return
	noMoreInput = true
	
	$PlayType.visible = true


func _on_settings_pressed() -> void:
	$ButtonPressed.play()
	%Settings.visible = !%Settings.visible


func _on_quit_pressed() -> void:
	$ButtonPressed.play()
	get_tree().quit()

func _on_play_mouse_entered() -> void:
	$ButtonHover.play()

func _on_settings_mouse_entered() -> void:
	$ButtonHover.play()

func _on_quit_mouse_entered() -> void:
	$ButtonHover.play()


var playTypeSelected : bool = false
func _on_yes_button_pressed() -> void:
	if playTypeSelected:
		return
	playTypeSelected = true
	$PlayButtonPressed.play()
	Game.gameManager.switchScene(tutorialLevel, 1.0, true)

func _on_no_button_pressed() -> void:
	if playTypeSelected:
		return
	playTypeSelected = true
	$PlayButtonPressed.play()
	Game.gameManager.switchScene(mainLevel, 1.0, true)
