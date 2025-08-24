class_name Bullet extends Projectile

const SPEED = 40.0

var velocity: Vector3 = Vector3.ZERO

func on_body_hit(body: Node3D):
	print("dingus")
	$HitSound.play()

func _physics_process(delta: float) -> void:
	self.position += velocity * delta

static func create(shooter: Player) -> Bullet:
	var new: Bullet = Scenes.bullet.instantiate()
	
	var direction = -shooter.facing_vec
	direction = Vector3(direction.x, 0, direction.y)
	new.player = shooter
	new.position = shooter.position + direction
	new.rotation = shooter.rotation
	new.velocity = shooter.linear_velocity + direction * SPEED
	return new;
