extends MultiplayerSpawner

@export var playerScene : PackedScene

func _enter_tree() -> void:
	for player in PlayerManager.players:
		spawn_player(player)
	
	PlayerManager.spawner_instance = self
	PlayerManager.on_player_added.connect(spawn_player)

func spawn_player(id: int):
	var player = Scenes.player.instantiate()
	player.id = id
	self.add_child(player)
