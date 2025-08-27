extends Node

const CONFIG_PATH = "user://settings.cfg"

var _settings = {
	"Controls": {
		"controllers_separate" = true,
		"keyboard_absolute_movement" = false,
		"controller_absolute_movement" = true,
	},
	"Audio": {
		"master_volume" = 1.0,
		"music_volume" = 0.5,
		"effects_volume" = 1.0,
	},
	"Display": {
		"fullscreen" = true,
		"crt_filter" = true,
	},
}

# internal
var max_health = 5.0

# variables
var config = ConfigFile.new()
var loaded_config = false

func get_setting(group: String, key: String):
	return _settings[group][key]

func set_setting(group: String, key: String, value):
	_settings[group][key] = value
	
	config.set_value(group, key, value)
	config.save(CONFIG_PATH)
	
	react_to_setting(group, key, value)
	
func react_to_setting(group: String, key: String, value):	
	match group:
		"Controls":
			pass
		"Audio":
			match key:
				"master_volume":
					_set_volume(value, "Master")
				"music_volume":
					_set_volume(value, "Music")
				"effects_volume":
					_set_volume(value, "Effects")
		"Display":
			match key:
				"fullscreen":
					if value:
						DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
					else:
						DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				"crt_filter":
					PostProcessing.CRT = value
					pass

func _ready() -> void:
	config.load(CONFIG_PATH)

	for group in _settings:
		for key in _settings[group]:
			_settings[group][key] = config.get_value(group, key, _settings[group][key])
			react_to_setting(group, key, _settings[group][key])
	config.save(CONFIG_PATH)

func _set_volume(volume: float, bus_name: String = "Master"):
	var bus = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_linear(bus, volume)
