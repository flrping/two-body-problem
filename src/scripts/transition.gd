# Usage: This object is 1x1 pixels, please scale the entire object rather than cloning it
# Use UI to change the "target" parameter to the desired scene

extends Node2D
@export var target: String = "";

var targetScene: PackedScene = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetScene = load(target)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_packed", targetScene)
