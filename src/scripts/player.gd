extends CharacterBody2D

var is_alive = true;

const SPEED = 380.0
const JUMP_VELOCITY = -450.0
const MAX_VELOCITY = 800
#the amount of extra velocity to remove when the jump button is not held
const FALL_TIGHTNESS = 20;

@onready var animation = $AnimatedSprite2D
@onready var spawn = get_tree().current_scene.get_node("Spawn")
@onready var corpse = preload("res://scenes/objects/dead_robot.tscn")

var run_transition_counter = 0;
var has_jumped = false
var is_holding_jump_key = false
var real_velocity = Vector2(0,0) #'actual' velocity before modifications are performed at the end
var disable_inputs = false #disable inputs without enabling respawn

#special event booleans
var disable_until_landed = false #used in 1st level

var camera: Camera2D
var lock_camera_y = false
var lock_camera_x = false
var locked_camera_offsets := Vector2(0,0)

signal has_died

var velocity_multipliers := [
	[-1000, -300, 1.4],
	[-300, 0, 0.8],
	[0, 100, 1.5],
	[100, 10000, 1.7]
]

func _ready() -> void:
	camera = self.get_node("Camera2D")
	
func _physics_process(delta: float) -> void:
	if disable_until_landed and is_on_floor():
		disable_until_landed = false
		disable_inputs = false
	
	# Add the gravity.
	if not is_on_floor():
		has_jumped = true
		real_velocity += get_gravity() * 1.1 * delta
	elif has_jumped:
		has_jumped = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and is_alive and !disable_inputs:
		real_velocity.y = JUMP_VELOCITY
		is_holding_jump_key = true
		
	if not Input.is_action_pressed("ui_accept"):
		is_holding_jump_key = false
	
	if not is_holding_jump_key and velocity.y < 0: 
		real_velocity.y += FALL_TIGHTNESS 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction and is_alive and !disable_inputs:
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
	elif is_alive:
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
	
	#do any post-movement camera adjustments
	if lock_camera_y:
		camera.position.y = locked_camera_offsets.y - position.y
	if lock_camera_x:
		camera.position.x = locked_camera_offsets.x - position.x

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_text_backspace") and not is_alive:
		real_velocity = Vector2(0,0)
		
		var _corpse = corpse.instantiate()
		# may not want to hard code this in the future, but time constraints! 
		# (player height - slightly less corpse height)
		var offset = (64 - 24) / 2 
		_corpse.position = position + Vector2(0, offset)
		get_tree().current_scene.add_child(_corpse)
		
		has_died.emit()
		
		var exists = get_tree().current_scene.get_node_or_null("Player/Camera2D/DeathScreen")
		if exists != null:
			exists.free()
		
		camera.position_smoothing_enabled = true
		animation.play("reanimate")
		await animation.animation_finished
		
		position = spawn.position
		is_alive = true

func set_locked_camera(x, y, enable_x: bool, enable_y: bool):
	lock_camera_x = enable_x
	lock_camera_y = enable_y
	locked_camera_offsets = Vector2(x,y)	

func disable_inputs_until_landed():
	disable_until_landed = true
	disable_inputs = true
