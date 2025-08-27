extends Slider

@export var category: String 
@export var key: String 

func _ready() -> void:
	self.value_changed.connect(on_changed)
	self.value = GameSettings.get_setting(category, key)
	
func on_changed(value):
	GameSettings.set_setting(category, key, value)
