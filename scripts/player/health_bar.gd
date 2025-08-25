extends Node3D

var fill: float = 1.0:
	set(value):
		fill = clamp(value, 0, 1)
		$Bar.scale.x = fill
		#$Bar.position.x = -fill / 2
