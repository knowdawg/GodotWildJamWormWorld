extends Control
class_name MainMenuUI


func _on_play_pressed() -> void:
	pass # Replace with function body.


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
