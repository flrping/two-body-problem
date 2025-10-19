extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animation = $AnimatedSprite2D

var run_transition_counter = 0;
var has_jumped = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		has_jumped = true
		velocity += get_gravity() * delta
	elif has_jumped:
		has_jumped = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		if velocity.x == 0:
			run_transition_counter = 0.07
			animation.play("run_start")
			
		velocity.x = direction * SPEED
		
		if run_transition_counter > 0:
			run_transition_counter -= delta
		else:
			animation.play("run")
		
		if velocity.x < 0:
			animation.flip_h = true
		else:
			animation.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")

	move_and_slide()
