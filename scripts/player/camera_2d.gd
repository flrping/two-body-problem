extends Camera2D

var player
var camera_offset := Vector2.ZERO
var time = 0.0

const DISTANCE = 30.0
const MOVE_SPEED = 5.0
const RETURN_SPEED = 4.0
const TIMEOUT = 3.0

func _process(delta: float) -> void:
	var is_idle = player.current_state == player.states["idle"]
	
	if is_idle:
		time += delta
	else:
		time = 0.0
	
	if is_idle:
		if time > TIMEOUT:
			camera_offset = camera_offset.lerp(Vector2.ZERO, delta * RETURN_SPEED)
		else:
			camera_offset = camera_offset.lerp(Vector2.ZERO, 0)
	else:
		# var direction = -1 if player.animation.flip_h else 1
		var direction = sign(player.velocity.x)
		var target_offset = Vector2(direction * DISTANCE, 0)
		camera_offset = camera_offset.lerp(target_offset, delta * MOVE_SPEED)
	
	offset = camera_offset
