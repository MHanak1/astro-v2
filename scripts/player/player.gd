class_name Player extends CharacterBody3D

@export var id = 0;

@export var speed = 5.0

@export var velocity_damping = 1
@export var angular_velocity_damping = 7.5
@export var camera_follow_speed = 20.0


var angular_velocity = 0
var movement_input = Vector2.ZERO
var facing_towards = Vector2.ZERO

var facing_vec: Vector2: 
	get:
		return Vector2.from_angle(-self.rotation.y + PI/2)
var camera: Camera3D:
	get:
		return $Camera3D

static func create(id: int) -> Player:
	var new = new()
	new.id = id
	return new

func _physics_process(delta: float) -> void:
	update_velocities(delta)
	
	self.rotation.y += delta * angular_velocity
	move_and_slide()

func _process(delta: float) -> void:
	handle_inputs(delta)
	update_particles()
	update_camera(delta)

func update_camera(delta: float):
	#var lerped = camera.position.lerp(self.position, delta * camera_follow_speed)
	#camera.position.x = lerped.x
	#camera.position.z = lerped.z
	camera.position.x = position.x
	camera.position.z = position.z

func update_particles():
	$Thrusters/Main.intensity = -movement_input.y
	print($Thrusters/Main.intensity , ", ", movement_input.y)
	var angle = self.facing_towards.angle_to(self.facing_vec)
	if abs(angle) < 0.1:
		angle = 0
	
	$Thrusters/LeftBack.intensity = -angle
	$Thrusters/RightForward.intensity = -angle

	$Thrusters/RightBack.intensity = angle
	$Thrusters/LeftForward.intensity = angle


func update_velocities(delta: float):
	if self.facing_towards.length_squared() > 0.01:
		var angle = self.facing_towards.angle_to(self.facing_vec)
		self.angular_velocity += angle * delta * 50
	
	
	self.velocity -= self.velocity * delta * velocity_damping
	self.angular_velocity -= self.angular_velocity * delta * angular_velocity_damping
	

func handle_inputs(delta: float):
	var input = InputManager.get_player_input(self.id)
	movement_input = input.movement
	var movement: Vector2 = movement_input.rotated(-self.rotation.y) * speed * delta * 10
	self.velocity.x += movement.x
	self.velocity.z += movement.y
	
	self.facing_towards = input.facing
	
	if input.facing_screen_space:
		var player_screen_pos = get_viewport().get_camera_3d().unproject_position(self.position)
		
		self.facing_towards = (player_screen_pos - input.facing).normalized()
