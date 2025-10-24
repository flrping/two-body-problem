extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("Player").set_locked_camera(0, -50, false, true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
