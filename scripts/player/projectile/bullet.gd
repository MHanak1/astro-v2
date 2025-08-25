class_name Bullet extends Projectile

const SPEED = 40.0

func on_body_hit(body: Node3D):
	#TODO: fix me
	
	if body is RigidBody3D:
		body.apply_impulse(velocity.normalized() * 20, position - body.position)

	
	$HitSound.play()

static func create(shooter: Player) -> Bullet:
	var new: Bullet = Scenes.bullet.instantiate()
	
	var direction = -shooter.facing_vec
	direction = Vector3(direction.x, 0, direction.y)
	new.player = shooter
	new.position = shooter.position + direction
	new.rotation = shooter.rotation
	new.velocity = shooter.linear_velocity + direction * SPEED
	return new;
