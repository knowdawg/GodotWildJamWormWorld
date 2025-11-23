extends MarginContainer
class_name Settings


func _ready() -> void:
	$Panel/MarginContainer/VBoxContainer/HBoxContainer/ScreenShake.button_pressed = Game.screenShake
	$Panel/MarginContainer/VBoxContainer/HBoxContainer/PreformanceMode.button_pressed = Game.performanceMode
	
	$Panel/MarginContainer/VBoxContainer/MasterSlider.value = AudioServer.get_bus_volume_linear(0) * 100.0
	$Panel/MarginContainer/VBoxContainer/SoundSlider.value = AudioServer.get_bus_volume_linear(2) * 100.0
	$Panel/MarginContainer/VBoxContainer/MusicSlider.value = AudioServer.get_bus_volume_linear(1) * 100.0


func _on_settings_exit_pressed() -> void:
	$ButtonPressed.play()
	visible = false



func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, (value / 100.0) + 0.01)

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, (value / 100.0) + 0.01)

func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, (value / 100.0) + 0.01)


func _on_screen_shake_toggled(toggled_on: bool) -> void:
	Game.screenShake = toggled_on


func _on_preformance_mode_toggled(toggled_on: bool) -> void:
	Game.performanceMode = toggled_on
	if toggled_on:
		Engine.max_fps = 30
	else:
		Engine.max_fps = 60
