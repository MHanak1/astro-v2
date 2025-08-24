extends Node

var player: PackedScene
var bullet: PackedScene

func _enter_tree() -> void:
	print("2")
	player = load("res://scenes/player/player.tscn")
	bullet = load("res://scenes/player/bullet.tscn")
