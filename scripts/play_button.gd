extends Button

@onready var scene = load("res://scenes/levels/l1_p1_start_text.tscn")

func _on_play_pressed() -> void:
	Global.init()
	get_tree().change_scene_to_packed(scene)
