extends Camera3D

@export var locked = false

func _process(delta: float):
	var player = PlayerManager.get_player(PlayerManager.focused_player)
	if (!locked && player):
		self.position.x = player.position.x
		self.position.z = player.position.z
