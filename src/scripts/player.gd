extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -450.0
const MAX_VELOCITY = 800
#the amount of extra velocity to remove when the jump button is not held
const FALL_TIGHTNESS = 20;

@onready var animation = $AnimatedSprite2D

var run_transition_counter = 0;
var has_jumped = false
var is_holding_jump_key = false
var real_velocity = Vector2(0,0) #'actual' velocity before modifications are performed at the end

var velocity_multipliers := [
	[-1000, -300, 1.4],
	[-300, 0, 0.8],
	[0, 100, 1.5],
	[100, 10000, 1.7]
]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		has_jumped = true
		real_velocity += get_gravity() * 1.1 * delta
	elif has_jumped:
		has_jumped = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		real_velocity.y = JUMP_VELOCITY
		is_holding_jump_key = true
		
	if not Input.is_action_pressed("ui_accept"):
		is_holding_jump_key = false
	
	if not is_holding_jump_key and velocity.y < 0: 
		real_velocity.y += FALL_TIGHTNESS 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		#run_start animation
		if real_velocity.x == 0:
			run_transition_counter = 0.07
			animation.play("run_start")
			
		real_velocity.x = direction * SPEED
		
		if run_transition_counter > 0:
			run_transition_counter -= delta
		else:
			animation.play("run")
		
		if real_velocity.x < 0:
			animation.flip_h = true
		else:
			animation.flip_h = false
	else:
		real_velocity.x = move_toward(real_velocity.x, 0, SPEED)
		animation.play("idle")
		
	velocity.x = real_velocity.x
	velocity.y = real_velocity.y
	
	for val in velocity_multipliers:
		if real_velocity.y >= val[0] and real_velocity.y < val[1]:
			velocity.y *= val[2]
			break
		velocity.y = real_velocity.y
		
	velocity.y = clamp(velocity.y, -1 * MAX_VELOCITY, MAX_VELOCITY )

	move_and_slide()
