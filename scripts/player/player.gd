extends CharacterBody2D

var is_alive = true;

@export var debug = false

const SPEED = 380.0
const JUMP_VELOCITY = -650.0
const MAX_VELOCITY = 800
#the amount of extra velocity to remove when the jump button is not held
const FALL_TIGHTNESS = 10;

@onready var animation = $AnimatedSprite2D
@onready var death_audio = [
	preload("res://assets/audio/Random6 (1).wav"),
	preload("res://assets/audio/Random6 (2).wav"),
	preload("res://assets/audio/Random6.wav"),
]

var run_transition_counter = 0;
var has_jumped = false
var is_holding_jump_key = false
var real_velocity = Vector2(0,0) #'actual' velocity before modifications are performed at the end
var disable_inputs = false #disable inputs without enabling respawn

# special event booleans
var disable_until_landed = false #used in 1st level
var death_anim_triggered = false #use to prevent death events from triggering more than once

var camera: Camera2D
var lock_camera_y = false
var lock_camera_x = false
var locked_camera_offsets := Vector2(0,0)

var current_state
var states = {}

signal has_died

var velocity_multipliers := [
	[-1000, -300, 1.4],
	[-300, 0, 0.8],
	[0, 100, 1.5],
	[100, 10000, 1.7]
]

func _ready() -> void:
	states = {
		"idle": preload("res://scripts/player/states/player_idle_state.gd").new(),
		"run": preload("res://scripts/player/states/player_run_state.gd").new(),
		"jump": preload("res://scripts/player/states/player_jump_state.gd").new(),
		"wall_grab": preload("res://scripts/player/states/player_wall_grab_state.gd").new(),
		"revive": preload("res://scripts/player/states/player_revive_state.gd").new(),
	}

	for state in states.values():
		state.player = self
		add_child(state)
		
	change_state("idle")
	camera = self.get_node("Camera2D")
	
	get_tree().connect("node_added", _on_node_added)
	await get_tree().process_frame
	for node in get_tree().get_nodes_in_group("Hazards"):
		node.player_died.connect(_on_player_died)


func change_state(state_name: String):
	if not states.has(state_name):
		push_warning("State '%s' not found" % state_name)
		return

	if current_state == states[state_name]:
		return

	if current_state:
		current_state.exit(states[state_name])

	var prev = current_state
	current_state = states[state_name]
	current_state.enter(prev)

func _physics_process(delta: float) -> void:
	if not current_state:
		return
	current_state.handle_input(null)
	current_state.physics_update(delta)
	
	if not is_on_floor():
		real_velocity += get_gravity() *  delta
		
	velocity = real_velocity
	
	# Apply velocity multipliers to vertical motion
	velocity.x = real_velocity.x
	velocity.y = real_velocity.y
	for val in velocity_multipliers:
		if real_velocity.y >= val[0] and real_velocity.y < val[1]:
			velocity.y *= val[2]
			break

	velocity.y = clamp(velocity.y, -1.0 * MAX_VELOCITY, MAX_VELOCITY)
	move_and_slide()
	
	# post-movement camera locks
	if lock_camera_y:
		camera.position.y = locked_camera_offsets.y - position.y
	if lock_camera_x:
		camera.position.x = locked_camera_offsets.x - position.x
		
	# landing gate used by scripted events
	if disable_until_landed and is_on_floor():
		disable_until_landed = false
		disable_inputs = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_text_backspace") and not is_alive and not death_anim_triggered:
		death_anim_triggered = true
		
		var exists = get_tree().current_scene.get_node_or_null("Player/Camera2D/DeathScreen")
		if exists != null:
			exists.free()
		
		camera.position_smoothing_enabled = true
		animation.play("reanimate")
		get_node("Revive").play()
		await animation.animation_finished
		
		Global.move_and_spawn_player(self)
		is_alive = true
		death_anim_triggered = false
		
		MusicPlayer.change_song(preload("res://assets/audio/tracks/area 1.wav"))

func set_locked_camera(x, y, enable_x: bool, enable_y: bool):
	lock_camera_x = enable_x
	lock_camera_y = enable_y
	locked_camera_offsets = Vector2(x,y)	

func disable_inputs_until_landed():
	disable_until_landed = true
	disable_inputs = true
	
func _on_node_added(node):
	if node is HazardArea2D:
		node.player_died.connect(_on_player_died)
		
func _on_player_died(_body, hazard: String):
	MusicPlayer.change_song(preload("res://assets/audio/tracks/death.wav"))
	
	var _stream = get_node("Death")
	if death_audio.size() > 0:
		_stream.stream = death_audio[randi_range(0, death_audio.size() - 1)]
		_stream.play()
	
	if hazard.to_lower().contains("electricity"):
		return
	
	var offset = (64 - 24) / 2
	var type = "v" if hazard.ends_with("_v") else "h"
	var _corpse = Global.create_body(position + Vector2(0, offset), type)
	_corpse.flip_h = real_velocity.x >= 0
	has_died.emit(_corpse, type, hazard)
