extends Node2D

@onready var scene = load("res://scenes/levels/l1_p1_start_cutscene.tscn")

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_packed(scene)
