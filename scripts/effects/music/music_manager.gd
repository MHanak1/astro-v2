extends Node


func _ready() -> void:
	$Loop.timeout.connect(play_bar)
	
	play_bar()

func play_bar():
	$Lead.play()
