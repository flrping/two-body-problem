extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.get_node("Player").set_locked_camera(0, 150, false, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
