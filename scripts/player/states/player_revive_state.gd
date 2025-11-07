extends PlayerState

class_name ReviveState

func enter(_prev_state: PlayerState) -> void:
	player.death_anim_triggered = true
		
	var exists = get_tree().current_scene.get_node_or_null("Player/Camera2D/DeathScreen")
	if exists != null:
		exists.free()
		
	player.camera.position_smoothing_enabled = true
	player.animation.play("reanimate")
	player.get_node("Revive").play()
	await player.animation.animation_finished
		
	Global.move_and_spawn_player(player)
	player.is_alive = true
	player.death_anim_triggered = false
		
	MusicPlayer.change_song(preload("res://assets/audio/tracks/area 1.wav"))
	player.change_state("idle")
