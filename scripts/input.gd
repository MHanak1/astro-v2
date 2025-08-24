extends Node

var inputs = {}

var player_input_map = {}

signal on_new_device(device_id)

const DEADZONE = 0.2

class PlayerInput:
	var movement = Vector2(0, 0)
	var n_movement:
		get:
			if movement.length_squared() > 1.0:
				return movement.normalized()
			else:
				return movement
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
	if is_controller && GameSettings.controllers_separate:
		device += 1
	
	if !inputs.has(device):
		on_new_device.emit(device)
		inputs.set(device, PlayerInput.new())
	
	var input: PlayerInput = inputs[device]


	#mouse
	if event is InputEventMouseMotion:
		input.facing = event.position
		input.facing_screen_space = true
	elif event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				input.primary = event.is_pressed()
			MOUSE_BUTTON_RIGHT:
				input.secondary = event.is_pressed()

	
	#keyboard
	elif event is InputEventKey:
		match event.keycode:
			KEY_W, KEY_UP:
				if event.is_pressed():
					input.movement.y -= 1
				else:
					input.movement.y = 0
			KEY_S, KEY_DOWN:
				if event.is_pressed():
					input.movement.y += 1
				else:
					input.movement.y = 0
			KEY_A, KEY_LEFT:
				if event.is_pressed():
					input.movement.x -= 1
				else:
					input.movement.x = 0
			KEY_D, KEY_RIGHT:
				if event.is_pressed():
					input.movement.x += 1
				else:
					input.movement.x = 0
	
	#D-Pad
	elif event is InputEventJoypadButton:
		match event.button_index:
			JOY_BUTTON_START:
				if event.is_pressed() && event.device == 0: # only allow the 1st connected controller to trigger this
					self.controller_separate = !self.controller_separate
			JOY_BUTTON_DPAD_UP:
				if event.is_pressed():
					input.movement.y += 1
				else:
					input.movement.y = 0
			JOY_BUTTON_DPAD_DOWN:
				if event.is_pressed():
					input.movement.y -= 1
				else:
					input.movement.y = 0
			JOY_BUTTON_DPAD_LEFT:
				if event.is_pressed():
					input.movement.x -= 1
				else:
					input.movement.x = 0
			JOY_BUTTON_DPAD_RIGHT:
				if event.is_pressed():
					input.movement.x += 1
				else:
					input.movement.x = 0
			JOY_BUTTON_RIGHT_SHOULDER:
				input.primary = event.is_pressed()
			JOY_BUTTON_LEFT_SHOULDER:
				input.primary = event.is_pressed()

	#joystick
	elif event is InputEventJoypadMotion:
		input.facing_screen_space = false
		match event.axis:
			JOY_AXIS_LEFT_X:
				input.movement.x = event.axis_value
			JOY_AXIS_LEFT_Y:
				input.movement.y = event.axis_value
			JOY_AXIS_RIGHT_X:
				input.facing.x = -event.axis_value
			JOY_AXIS_RIGHT_Y:
				input.facing.y = -event.axis_value
	
	if input.movement.length() < DEADZONE:
		input.movement = Vector2(0, 0)
	if input.facing.length() < DEADZONE:
		input.facing = Vector2(0, 0)
	
	input.movement = input.movement.clamp(-Vector2.ONE, Vector2.ONE)

	#if input.movement.length_squared() > 1.0:
	#	input.movement = input.movement.normalized()
	#inputs[device].movement = movement
	
	
func get_player_input(pid: int) -> PlayerInput:
	if !player_input_map.has(pid):
		player_input_map.set(pid, player_input_map.size())
	
	if inputs.has(player_input_map.get(pid)):
		return inputs[player_input_map.get(pid)]
	else:
		return PlayerInput.new()
