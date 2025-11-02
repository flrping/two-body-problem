extends Control

func _ready() -> void:
	MusicPlayer.change_song(preload("res://assets/audio/tracks/credits.wav"))
