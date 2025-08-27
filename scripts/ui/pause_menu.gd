extends Window

func _init():
	self.visibility_changed.connect(on_visibility_changed)
	InputManager.game_pause_pressed.connect(on_pause_pressed)

func _exit_tree() -> void:
	Game.paused = false

func dingus():
	print("dingus")

func on_pause_pressed():
	print("aaa ", visible)

	self.visible = !self.visible

func on_visibility_changed():
	print("bbb ", visible)
	Game.paused = visible
	if !Game.is_multiplayer:
		get_tree().paused = visible
	if visible:
		$MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Back.grab_focus()


func _on_back_pressed() -> void:
	visible = false


func _on_options_pressed() -> void:
	$Settings.visible = true


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
