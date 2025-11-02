extends PlayerState
class_name IdleState

func enter(_prev_state):
	player.real_velocity.x = 0.0
	if player.animation.animation != "idle":
		player.animation.play("idle")

func handle_input(_event):
	if player.disable_inputs or not player.is_alive:
		return

	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.change_state("jump")
		return

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		player.change_state("run")

func physics_update(delta):
	# airborne transition
	if not player.is_on_floor():
		player.change_state("jump")
		return

	# smooth friction toward stop
	player.real_velocity.x = move_toward(player.real_velocity.x, 0.0, player.SPEED * delta * 5)
