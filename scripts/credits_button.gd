extends Button

@onready var scene = load("res://scenes/menu/credits.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_packed(scene)
