extends Node2D

@onready var scene = load("res://scenes/levels/l1_p1_start_cutscene.tscn")

func _ready() -> void:
	MusicPlayer.change_song(preload("res://assets/audio/soft-brown-noise-299934.mp3"))
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_packed(scene)
	MusicPlayer.change_song(preload("res://assets/audio/tracks/area 1.wav"))
