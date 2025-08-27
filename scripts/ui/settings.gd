extends Window


func _ready():
	self.visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if self.visible:
		$VBoxContainer/TabContainer.get_tab_bar().grab_focus()

func _on_button_pressed() -> void:
	self.visible = false
