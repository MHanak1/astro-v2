extends Node

var is_multiplayer = false;

func _init():
	print("1")

	RenderingServer.set_debug_generate_wireframes(true)
	
	#OS.set_environment("SteamAppID", str(480))
	#OS.set_environment("SteamGameID", str(480))

#func _ready():
	#Steam.steamInit()

#func _process(delta: float):
	#Steam.run_callbacks()
