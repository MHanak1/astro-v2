extends Node

var reset_timer = Timer.new()

func _ready() -> void:
	PlayerManager.player_died.connect(on_player_died)
	reset_timer.timeout.connect(next_scene)
	add_child(reset_timer)
	
	if self.has_node("PauseMenu"):
		Game.game_paused.connect(on_game_paused)

func on_game_paused(paused: bool):
	$PauseMenu/Menu.visible = paused

func on_player_died(pid: int):
	print("player_died")
	if pid == PlayerManager.focused_player:
		print("reloading")
		reset_timer.start(3)
		return
	
	#var living_players = 0
	#for player in PlayerManager.players:
	#	if PlayerManager.get_player(player).alive:
	#		living_players += 1
	#if living_players <= 1:
	#	reset_timer.start(3)
	#	return
	
func next_scene():
	get_tree().reload_current_scene()
