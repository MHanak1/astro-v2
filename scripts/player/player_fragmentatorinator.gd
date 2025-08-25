class_name Fragmentinator extends Node3D

@export var fragment_scene: PackedScene

func fragmentinate():
	var fragments: Node3D = fragment_scene.instantiate()
	fragments.position = self.get_parent_node_3d().position
	
	for fragment in fragments.get_children():
		var rigidbody = RigidBody3D.new()
		var mesh: Mesh = fragment.mesh
		
		rigidbody.top_level = true
		rigidbody.position = global_position
		rigidbody.rotation = global_rotation
		rigidbody.linear_velocity = get_parent_node_3d().linear_velocity
		rigidbody.linear_damp = 0.5
		rigidbody.angular_damp = 0.2
		rigidbody.center_of_mass = mesh.get_aabb().get_center()
		rigidbody.mass = 5

		
		rigidbody.apply_impulse(
			(
				mesh.get_aabb().get_center() +
				random_vec() * 0.05 +
				Vector3(0, randf_range(-0.3, 0.3), 0)
				) * 10.0
			)
		rigidbody.angular_velocity.y = randf_range(-2, 2)
		
		rigidbody.axis_lock_angular_x = true
		rigidbody.axis_lock_angular_z = true
		#rigidbody.axis_lock_linear_y = true
		
		rigidbody.add_child(fragment.duplicate())		
		
		self.add_child(rigidbody)

func random_vec() -> Vector3:
	return Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
