extends CanvasLayer
class_name MainMenuUI

var mainLevel : String = "uid://c5lmuy85ljtkk"


var noMoreInput : bool = false

func _process(delta: float) -> void:
	$Sprite2D.position = lerp($Sprite2D.position, $Sprite2D.get_global_mouse_position(), 10.0 * delta)

func _on_play_pressed() -> void:
	if noMoreInput:
		return
	noMoreInput = true
	
	if Game.gameManager:
		Game.gameManager.switchScene(mainLevel, 1.0, true)
	else:
		printerr("No Game Manager!")


func _on_settings_pressed() -> void:
	%Settings.visible = !%Settings.visible


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_exit_pressed() -> void:
	%Settings.visible = !%Settings.visible



func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, (value / 100.0) + 0.01)

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, (value / 100.0) + 0.01)

func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, (value / 100.0) + 0.01)
