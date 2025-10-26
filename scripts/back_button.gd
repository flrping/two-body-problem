extends Button

@onready var scene = load("res://scenes/menu/title.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_packed(scene)
