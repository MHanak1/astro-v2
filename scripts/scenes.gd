extends Node

var player: PackedScene
var bullet: PackedScene

var explosion: PackedScene
func _enter_tree() -> void:
	player = load("res://scenes/player/player.tscn")
	bullet = load("res://scenes/player/bullet.tscn")

	explosion = load("res://scenes/effects/explosion.tscn")
