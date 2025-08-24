extends Node3D

@export var size: float = 2.0
@export var pitch: float = 1.0
@export var intensity: float = 1.0: set = _set_intensity

var base_amount: int
var base_velocity_min: float
var base_velocity_max: float
var base_damping_min: float
var base_damping_max: float

func _ready() -> void:

	base_amount = $CPUParticles3D.amount
	base_velocity_min = $CPUParticles3D.initial_velocity_min
	base_velocity_max = $CPUParticles3D.initial_velocity_max
	base_damping_min = $CPUParticles3D.damping_min
	base_damping_max = $CPUParticles3D.damping_max
		
	_set_size(size)
	_set_intensity(intensity)

func _set_size(new_size: float):
	size = new_size

	#$CPUParticles3D.scale = Vector3.ONE * size * 0.5
	#$CPUParticles3D.scale_amount_min = size * 0.5
	#$CPUParticles3D.scale_amount_max = size * 0.5

func _set_intensity(new_intensity: float):
	intensity = new_intensity
	#if new_intensity > 0.0:
	#	$CPUParticles3D.emitting = true
	#		
	#else:
	#	intensity = 0
	#	$CPUParticles3D.emitting = false
	#if is_node_ready():
	#	$CPUParticles3D.velocity = intensity
	#	$CPUParticles3D.initial_velocity_min = base_velocity_min * intensity
	#	$CPUParticles3D.initial_velocity_max = base_velocity_max * intensity
	#	$CPUParticles3D.damping_min = base_damping_min * intensity
	#	$CPUParticles3D.damping_max = base_damping_max * intensity
