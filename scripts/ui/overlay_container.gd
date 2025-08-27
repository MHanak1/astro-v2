extends Control

@export var child: Window

func _ready():
	if child == null:
		push_error("Child is null")
		return
	child.visibility_changed.connect(_on_child_visibility_changed)
	self.visibility_changed.connect(_on_self_visibility_changed)

func _on_self_visibility_changed():
	child.visible = self.visible

func _on_child_visibility_changed():
	self.visible = child.visible
