extends Control

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_text_backspace"):
		var title = preload("res://scenes/menu/title.tscn")
		get_tree().call_deferred("change_scene_to_packed", title)
