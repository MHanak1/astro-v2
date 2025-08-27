extends Node

signal game_paused(paused: bool)

var is_multiplayer = false;

var paused: bool = false:
	set(new):
		paused = new
		game_paused.emit(paused)

func _init():
	RenderingServer.set_debug_generate_wireframes(true)
	
	#OS.set_environment("SteamAppID", str(480))
	#OS.set_environment("SteamGameID", str(480))

#func _ready():
	#Steam.steamInit()

#func _process(delta: float):
	#Steam.run_callbacks()
