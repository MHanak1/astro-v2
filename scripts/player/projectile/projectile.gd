class_name Projectile extends Area3D

var player: Player;

func _enter_tree() -> void:
	self.body_entered.connect(_on_body_hit)

static func create(shooter: Player) -> Projectile:
	push_warning("Projectile's spawn() was not overwritten")
	return Projectile.new()

func get_damage() -> float:
	return 1.0

func _on_body_hit(body: Node3D):
	if body == self.player:
		print("zenis")
		return
	if body.has_method("on_bullet_hit"):
		body.on_bullet_hit(self)
	on_body_hit(body)
	self.queue_free()
	
func on_body_hit(body: Node3D):
	pass
