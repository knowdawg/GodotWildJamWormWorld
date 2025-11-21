extends CanvasLayer
class_name MainMenuUI

var mainLevel : String = "uid://c5lmuy85ljtkk"


var noMoreInput : bool = false

func _ready() -> void:
	$Settings/Panel/MarginContainer/VBoxContainer/HBoxContainer/ScreenShake.button_pressed = Game.screenShake
	$Settings/Panel/MarginContainer/VBoxContainer/HBoxContainer/PreformanceMode.button_pressed = Game.performanceMode
	
	$Settings/Panel/MarginContainer/VBoxContainer/MasterSlider.value = AudioServer.get_bus_volume_linear(0) * 100.0
	$Settings/Panel/MarginContainer/VBoxContainer/SoundSlider.value = AudioServer.get_bus_volume_linear(2) * 100.0
	$Settings/Panel/MarginContainer/VBoxContainer/MusicSlider.value = AudioServer.get_bus_volume_linear(1) * 100.0

func _process(delta: float) -> void:
	$Sprite2D.position = lerp($Sprite2D.position, $Sprite2D.get_global_mouse_position(), 10.0 * delta)

func _on_play_pressed() -> void:
	$PlayButtonPressed.play()
	if noMoreInput:
		return
	noMoreInput = true
	
	if Game.gameManager:
		Game.gameManager.switchScene(mainLevel, 1.0, true)
	else:
		printerr("No Game Manager!")


func _on_settings_pressed() -> void:
	$ButtonPressed.play()
	%Settings.visible = !%Settings.visible


func _on_quit_pressed() -> void:
	$ButtonPressed.play()
	get_tree().quit()


func _on_settings_exit_pressed() -> void:
	$ButtonPressed.play()
	%Settings.visible = !%Settings.visible



func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, (value / 100.0) + 0.01)

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, (value / 100.0) + 0.01)

func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, (value / 100.0) + 0.01)


func _on_play_mouse_entered() -> void:
	$ButtonHover.play()

func _on_settings_mouse_entered() -> void:
	$ButtonHover.play()

func _on_quit_mouse_entered() -> void:
	$ButtonHover.play()


func _on_screen_shake_toggled(toggled_on: bool) -> void:
	Game.screenShake = toggled_on


func _on_preformance_mode_toggled(toggled_on: bool) -> void:
	Game.performanceMode = toggled_on
	if toggled_on:
		Engine.max_fps = 30
	else:
		Engine.max_fps = 60
