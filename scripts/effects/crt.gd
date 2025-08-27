extends CanvasLayer

var CRT: bool: 
	set(value):
		CRT = value
		$CRT.visible = value

func _ready():
	self.layer = 2000
