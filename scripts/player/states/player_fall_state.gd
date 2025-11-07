extends PlayerState

class_name FallState

func enter(_prev_state: PlayerState) -> void:
	if player.animation.animation != "jump":
		player.animation.play("jump")

func handle_input(_event: InputEvent) -> void:
	var direction := 0.0
	if player.is_alive and not player.disable_inputs:
		direction = Input.get_axis("ui_left", "ui_right")
		
	if direction != 0.0:
		player.real_velocity.x = direction * player.SPEED
		player.animation.flip_h = direction < 0.0

func physics_update(_delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# fall to wall grab
	# must be facing and going toward a grabbable object to hook on
	for i in range(player.get_slide_collision_count()):
		var collision = player.get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("WallGrab"):
			var normal = collision.get_normal()
			var pushing_toward_wall = (normal.x > 0 and direction < 0) or (normal.x < 0 and direction > 0)
			if pushing_toward_wall and player.real_velocity.y > 0 and abs(normal.y) < 0.5:
				var wall_grab_state = player.states["wall_grab"]
				wall_grab_state.wall_direction = sign(direction)
				player.change_state("wall_grab")
				return
	
	if player.is_on_floor():
		player.has_jumped = false
		if direction != 0.0:
			player.change_state("run")
		else:
			player.change_state("idle")
