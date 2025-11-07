extends PlayerState

class_name DeadState

func enter(_prev_state: PlayerState) -> void:
	player.real_velocity = Vector2.ZERO
	
	MusicPlayer.change_song(preload("res://assets/audio/tracks/death.wav"))
	 
	var _stream = player.get_node("Death")
	if player.death_audio.size() > 0:
		_stream.stream = player.death_audio[randi_range(0, player.death_audio.size() - 1)]
		_stream.play()

func handle_input(_event: InputEvent) -> void:
	# Respawn on backspace
	if Input.is_action_pressed("ui_text_backspace") and not player.is_alive and not player.death_anim_triggered:
		player.change_state("revive")
		return
