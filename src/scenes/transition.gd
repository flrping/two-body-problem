# Usage: This object is 1x1 pixels, please scale the entire object rather than cloning it
# Use UI to change the "target" parameter to the desired scene

extends Node2D
@export var target: PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	#get_tree().change_scene_to_file(target)
	var result = get_tree().change_scene_to_packed(target)
	print(result)
