extends Node

var is_ready = false

func _ready() -> void:
	$VBoxContainer/MarginContainer2/VBoxContainer/Play.grab_focus()
	is_ready = true
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/lobby.tscn")

func _on_options_pressed() -> void:
	$SettingsPanel.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()

func on_hover():
	if is_ready:
#		$UIHover.play()
		pass
