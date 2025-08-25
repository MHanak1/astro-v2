class_name Explosion extends Node3D

static func create(position: Vector3 = Vector3.ZERO) -> Explosion:
	var node = Scenes.explosion.instantiate()
	#node.position = position
	return node

func explode():
	$Large.emitting = true
	$Small.emitting = true
	$Sound.play()
	
	$Large.finished.connect(queue_free)
