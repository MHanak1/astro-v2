extends Camera3D

@export var locked = false

var audio_listener = AudioListener3D.new()


func _enter_tree() -> void:
	self.add_child(audio_listener)
	audio_listener.make_current()
	

func _process(delta: float):
	audio_listener.global_position.y = 5
	
	if locked:
		return
	
	if Game.is_multiplayer || PlayerManager.players.size() == 1:
		var player = PlayerManager.get_player(PlayerManager.focused_player)
		if (player):
			self.position.x = player.position.x
			self.position.z = player.position.z
			
	else:
		var player_bb_min = null
		var player_bb_max = null
		
		for pid in PlayerManager.players:
			var player = PlayerManager.get_player(pid)
			if player.controllable:
				if player_bb_min == null:
					player_bb_min = player.position
					player_bb_max = player.position
				else:
					player_bb_min = player_bb_min.min(player.position)
					player_bb_max = player_bb_max.max(player.position)
				
				player_bb_min = player_bb_min.min(player.position + player.linear_velocity * 0.5)
				player_bb_max = player_bb_max.max(player.position + player.linear_velocity * 0.5)
		
		var center = (player_bb_min + player_bb_max) / 2
		var size = player_bb_max - player_bb_min
		var screen_size = get_viewport().get_visible_rect().size
		var ratio = screen_size.x / screen_size.y
		
		print (player_bb_min)
		print(player_bb_max)
		print(center)
		print(size)
		
		var target_position = Vector3.ZERO;
		
		target_position.x = center.x
		target_position.z = center.z
		target_position.y = max(20, max(size.x, size.z * ratio)* 0.6)
		
		self.position = lerp(position, target_position, delta * 5)
