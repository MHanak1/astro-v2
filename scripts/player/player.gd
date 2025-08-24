class_name Player extends RigidBody3D

@export var id = 0:
	set(new):
		id = new
		self.name = "Player %d" % id
@export var speed = 5.0

const velocity_damping = 1
const angular_velocity_damping = 7.5
const VOLUME = 0.45

var age: float = 0
 
var movement_input = Vector2.ZERO
var facing_towards = Vector2.ZERO

var last_shot: float = -10.0;

var bullet_scene = preload("res://scenes/player/bullet.tscn")


var health: float = 5.0:
	set(new):
		health = new
		if health < 0.0:
			kill()
var facing_vec: Vector2: 
	get:
		return Vector2.from_angle(-self.rotation.y + PI/2)
var alive: bool:
	get:
		return health > 0.0

static func create(id: int) -> Player:
	var new = new()
	new.id = id
	return new

func _ready() -> void:
	id = id

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	update_velocities(state)

func _process(delta: float) -> void:
	age += delta
	if id < 0:
		return
	update_effects()
	handle_inputs()

func shoot():
	if age - last_shot > 0.2:
		last_shot = age
		$Sounds/Shoot.play()
		var bullet = Bullet.create(self)
		self.add_child(bullet)

func on_bullet_hit(bullet: Projectile):
	self.health -= bullet.get_damage()
	
func kill():
	self.queue_free()

func update_effects():
	if !movement_input:
		movement_input = Vector2.ZERO
		
	$Thrusters/Main.intensity = -movement_input.y
	var angle = self.facing_towards.angle_to(self.facing_vec)
	
	$Thrusters/LeftBackward.intensity = -angle
	$Thrusters/RightForward.intensity = max(-angle, movement_input.y)

	$Thrusters/RightBackward.intensity = angle
	$Thrusters/LeftForward.intensity =  max(angle, movement_input.y)

	$Thrusters/Left.intensity = movement_input.x
	$Thrusters/Right.intensity = -movement_input.x
	
	$Sounds/ThrusterBig.volume_linear = -movement_input.y * VOLUME
	$Sounds/ThrusterSmall.volume_linear = clamp(max(abs(angle), movement_input.y, abs(movement_input.x)), 0.0, 1.0) * 0.6 * VOLUME

	#$Sounds/ThrusterBig.pitch_scale = clamp($Sounds/ThrusterBig.pitch_scale + randf_range(-0.01, 0.01), 0.9, 1.1)
	#$Sounds/ThrusterSmall.pitch_scale = clamp($Sounds/ThrusterSmall.pitch_scale + randf_range(-0.01, 0.01), 0.9, 1.1) 


func update_velocities(state: PhysicsDirectBodyState3D):
	
	if self.facing_towards.length_squared() > 0.01:
		var angle = self.facing_towards.angle_to(self.facing_vec)
		self.apply_torque(Vector3(0, angle * 500, 0))
		#state.apply_force()
	
	var movement: Vector2 = movement_input
	movement.x *= 0.5
	movement = movement.rotated(-self.rotation.y) * speed * 200
	
	state.apply_force(Vector3(movement.x, 0, movement.y))
	
	state.apply_force(Vector3(state.linear_velocity.x, 0, state.linear_velocity.z) * -20)
	state.apply_torque(Vector3(0, state.angular_velocity.y, 0) * -100)

	
	#self.linear_velocity -= self.linear_velocity * delta * velocity_damping
	#self.angular_velocity -= self.angular_velocity * delta * angular_velocity_damping
	

func handle_inputs():
	var input = InputManager.get_player_input(self.id)
	movement_input = input.movement
	
	self.facing_towards = input.facing
	
	if input.facing_screen_space:
		var player_screen_pos = get_viewport().get_camera_3d().unproject_position(self.position)
		
		self.facing_towards = (player_screen_pos - input.facing).normalized()
	
	if input.primary:
		shoot()
