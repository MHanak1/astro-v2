extends Node3D

@export var pitch: float = 1.0
@export var intensity: float = 0.0: set = _set_intensity

var base_amount: int
var base_velocity_min: float
var base_velocity_max: float
var base_damping_min: float
var base_damping_max: float

func _ready():
	_set_intensity(intensity)

func _set_intensity(new_intensity: float):
	intensity = new_intensity
	
	$Particles.amount_ratio = intensity
