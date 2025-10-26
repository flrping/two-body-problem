extends Node2D

var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("Player")
	player.disable_inputs_until_landed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
