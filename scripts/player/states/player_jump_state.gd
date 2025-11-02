extends PlayerState

class_name JumpState

func enter(_prev_state):
	# initial takeoff only when coming from floor
	player.animation.play("jump")
	if player.is_on_floor() and player.is_alive and not player.disable_inputs:
		player.real_velocity.y = player.JUMP_VELOCITY
		player.is_holding_jump_key = true
	player.has_jumped = true

func handle_input(_event):
	# jump hold/cut
	if not Input.is_action_pressed("ui_accept"):
		player.is_holding_jump_key = false

func physics_update(delta):
	player.real_velocity += player.get_gravity() * 1.1 * delta
	
	# horizontal air control
	var direction := 0.0
	if player.is_alive and not player.disable_inputs:
		direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		player.real_velocity.x = direction * player.SPEED
		player.animation.flip_h = player.real_velocity.x < 0.0
		
	# variable jump height (cut upward velocity when key released)
	if not player.is_holding_jump_key and player.velocity.y < 0.0:
		player.real_velocity.y += player.FALL_TIGHTNESS
		
	# land -> idle/run
	if player.is_on_floor():
		player.has_jumped = false
		if direction != 0.0:
			player.change_state("run")
		else:
			player.change_state("idle")
