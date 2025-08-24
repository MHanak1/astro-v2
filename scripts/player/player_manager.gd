extends Node

@export var spawn_positions: Array[Node3D]


var players: Array[int];
var focused_player = 0
var authorities = {}

var instance;

signal on_player_added(pid)
signal on_player_removed(pid)

signal focused_player_changed(new_id)

func get_player(player_id: int) -> Player:
	if instance != null:
		return instance.get_node("Player %d" % player_id)
	else:
		return null

@rpc("authority", "call_local", "reliable")
func new_player() -> int:
	var player_id = players.size()
	create_player(player_id)
	return player_id
	
@rpc("authority", "call_local", "reliable")
func create_player(player_id: int) -> Player:
	print("create_player ", player_id)
	if !players.has(player_id):
		players.append(player_id)
		on_player_added.emit(player_id)
	if instance != null:
		return get_player(player_id)
	else:
		return null
		#players[player_id] = Player.create(player_id)

func reset_player(player_id: int):
	get_player(player_id).replace_by(Player.create(player_id))

func delete_player(player_id: int):
	players.erase(player_id)
	on_player_removed.emit(player_id)

func make_current(player_id):
	focused_player = player_id
	focused_player_changed.emit(player_id)

func on_focused_player_changed(player_id):
	print("focused_player_changed")
	var player = get_player(player_id)
	print(player)
	#if player != null:
		#Game.set_camera(player.camera())
	
func set_authority(player_id: int, authority: int):
	if player_id == 0 && authority != 1:
		print("uh oh")
	print("setting authority for ", player_id, ": ", authority)
	authorities.set(player_id, authority)
