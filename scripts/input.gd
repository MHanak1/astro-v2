extends Node

var inputs = {}

var player_input_map = {}

signal on_new_device(device_id)

class PlayerInput:
	var movement = Vector2(0, 0)
	var facing = Vector2(0, 0)
	#false means controller joypad, where the facing value is already where the player should be looking
	#true means it's a mouse position on screen position
	var facing_screen_space: bool
	var primary
	var secondary

func _input(event: InputEvent) -> void:
	var is_controller = false
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		is_controller = true
	
	# this means only one keyboard is supported, if anyone needs multi keyboard support let me know
	var device = event.device
	if is_controller:
		device += 1
	
	if !inputs.has(device):
		on_new_device.emit(device)
		inputs.set(device, PlayerInput.new())
	
	var input: PlayerInput = inputs[device]

	# movement
	input.movement.x = Input.get_axis("move_left", "move_right")
	input.movement.y = Input.get_axis("move_up", "move_down")
	if input.movement.length_squared() > 1.0:
		input.movement = input.movement.normalized()
	#inputs[device].movement = movement
	
	# facing
	if event is InputEventMouseMotion:
		input.facing = event.position
		input.facing_screen_space = true
	
func get_player_input(pid: int) -> PlayerInput:
	if !player_input_map.has(pid):
		player_input_map.set(pid, player_input_map.size())
	
	if inputs.has(player_input_map.get(pid)):
		return inputs[player_input_map.get(pid)]
	else:
		return PlayerInput.new()
