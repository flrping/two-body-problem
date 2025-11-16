extends PlayerState

class_name ReviveState

func enter(_prev_state: PlayerState) -> void:
	player.death_anim_triggered = true
		
	var exists = get_tree().current_scene.get_node_or_null("Player/Camera2D/DeathScreen")
	if exists != null:
		exists.free()
		
	player.animation.play("reanimate")
	player.get_node("Revive").play()
	await player.animation.animation_finished
	
	if not Global.has_died_once:
		Global.has_died_once = true
		get_tree().call_deferred("change_scene_to_packed", load("res://scenes/levels/l1_p1.tscn"))
	else:
		Global.move_and_spawn_player(player)
		player.is_alive = true
		player.death_anim_triggered = false
		player.change_state("idle")
		
	MusicPlayer.change_song(preload("res://assets/audio/tracks/area 1.wav"))
