class_name Player extends RigidBody3D

@export var id: int = 0:
	set(new):
		id = new
		self.name = "Player %d" % id
@export var speed = 5.0


const velocity_damping = 1
const angular_velocity_damping = 7.5
const VOLUME = 0.45

var collided_this_frame = false
var age: float = 0
 
var movement_input = Vector2.ZERO
var facing_towards = Vector2.ZERO

var last_shot: float = -10.0;

var bullet_scene = preload("res://scenes/player/bullet.tscn")

var health: float = GameSettings.max_health:
	set(new):
		if health > 0.0001 && new < 0.0001:
			_kill()
		health = new
		$Floating/HealthBar.fill = health / GameSettings.max_health

var controllable: bool:
	get:
		return alive && id >= 0
var facing_vec: Vector2: 
	get:
		return Vector2.from_angle(-self.rotation.y + PI/2)
var alive: bool:
	get:
		return health > 0.0

static func create(id: int) -> Player:
	var new = new()
	new.id = id
	return 

func kill():
	health = 0

func _kill():
	var explosion = Explosion.create(self.position)
	add_child(explosion)
	explosion.explode()
	$Fragmentinator.fragmentinate()
	
	$Mesh.visible = false
	$Floating.visible = false
	if $Hitbox:
		$Hitbox.queue_free()
	PlayerManager.player_died.emit(id)
	#self.queue_free()
	#$Destruction.destroy()


func _ready() -> void:
	id = id
	self.body_entered.connect(on_collision)
	
func on_collision(body: Node):
	if body is Player:
		if !collided_this_frame:
			collided_this_frame = true
			var other_velocity = body.linear_velocity
			var force = abs((other_velocity - self.linear_velocity).length())
			force = (force - 8.0) * 0.25
			if force < 0:
				return
			self.health -= force
			if !body.collided_this_frame:
				body.health -= force
				body.collided_this_frame = true

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	update_velocities(state)
	
func _process(delta: float) -> void:
	age += delta
	
	$Floating.position = position
	
	# Genius player AI
	#if id < 0:
	#	self.facing_towards.x = self.facing_towards.x + randf_range(-0.3, 0.3)
	#	self.facing_towards.y = self.facing_towards.y + randf_range(-0.3, 0.3)
	#	self.facing_towards = self.facing_towards.normalized()
	#	self.movement_input.y = -1

	update_effects()
	if controllable:
		handle_inputs()
	collided_this_frame = false


func shoot():
	if age - last_shot > 0.2:
		last_shot = age
		$Sounds/Shoot.play()
		var bullet = Bullet.create(self)
		self.add_child(bullet)

func on_bullet_hit(bullet: Projectile):
	self.health -= bullet.get_damage()

func update_effects():
	var angle = self.facing_towards.angle_to(self.facing_vec)
	angle = fmod(angle, PI)
	if !controllable:
		movement_input = Vector2.ZERO
		angle = 0
	
	$Thrusters/Main.intensity = -movement_input.y
	
	$Thrusters/LeftBackward.intensity = -angle
	$Thrusters/RightForward.intensity = max(-angle, movement_input.y)

	$Thrusters/RightBackward.intensity = angle
	$Thrusters/LeftForward.intensity =  max(angle, movement_input.y)

	$Thrusters/Left.intensity = movement_input.x
	$Thrusters/Right.intensity = -movement_input.x
	
	$Sounds/ThrusterBig.volume_linear = max(0, -movement_input.y * VOLUME)
	$Sounds/ThrusterSmall.volume_linear = clamp(max(abs(angle), movement_input.y, abs(movement_input.x)), 0.0, 1.0) * 0.6 * VOLUME

	#$Sounds/ThrusterBig.pitch_scale = clamp($Sounds/ThrusterBig.pitch_scale + randf_range(-0.01, 0.01), 0.9, 1.1)
	#$Sounds/ThrusterSmall.pitch_scale = clamp($Sounds/ThrusterSmall.pitch_scale + randf_range(-0.01, 0.01), 0.9, 1.1) 


func update_velocities(state: PhysicsDirectBodyState3D):
	
	if self.facing_towards.length_squared() > 0.01:
		var angle = self.facing_towards.angle_to(self.facing_vec)
		self.apply_torque(Vector3(0, angle * 500, 0))
		#state.apply_force()
	
	var movement: Vector2 = movement_input
	if movement.length_squared() > 1.0:
		movement = movement.normalized()
	movement.x *= 0.5
	movement = movement * speed * 200
	
	movement = movement.rotated(-self.rotation.y)
	
	state.apply_force(Vector3(movement.x, 0, movement.y))
	
	state.apply_force(Vector3(state.linear_velocity.x, 0, state.linear_velocity.z) * -20)
	state.apply_torque(Vector3(0, state.angular_velocity.y, 0) * -100)

	
	#self.linear_velocity -= self.linear_velocity * delta * velocity_damping
	#self.angular_velocity -= self.angular_velocity * delta * angular_velocity_damping
	

func handle_inputs():
	var input = InputManager.get_player_input(self.id)
	movement_input = input.movement
	if input.movement_absolute:
		movement_input = movement_input.rotated(rotation.y)
	
	
	self.facing_towards = input.facing
	
	if input.facing_screen_space:
		var player_screen_pos = get_viewport().get_camera_3d().unproject_position(self.position)
		
		self.facing_towards = (player_screen_pos - input.facing).normalized()
	
	if input.primary:
		shoot()
	if input.secondary:
		kill()
