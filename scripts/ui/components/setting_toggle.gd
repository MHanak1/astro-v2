extends Button

@export var category: String 
@export var key: String 

func _ready() -> void:
	self.toggled.connect(on_toggled)
	self.button_pressed = GameSettings.get_setting(category, key)
	
func on_toggled(value):
	GameSettings.set_setting(category, key, value)
