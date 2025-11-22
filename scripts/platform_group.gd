extends Node2D

class_name PlatformGroup

@export var speed := 100.0
@export var current_node = null
@export var nodes: Array[Node2D] = []
@export var index = 0
@export var mode := "circular"
@export var trigger := "auto"

var triggers = ["auto", "player"]
var modes = ["circular", "one-shot", "back-forth"]

var activated = false
var direction := 1 

@onready var platform = $Platform as Platform
@onready var platform_area = $Platform/Area2D

func _ready() -> void:
	for node in get_children():
		if node.name.begins_with("Point_"):
			nodes.append(node)
	
	nodes.sort()
	if nodes.size() > 0 and nodes.size() > index:
		current_node = nodes[index]
		
	if trigger not in triggers:
		print("Invalid trigger, using auto")
		trigger = "auto"
	
	if mode not in modes:
		print("Invalid mode, using circular")
		mode = "circular"
	
	if trigger == "auto":
		activated = true

func _physics_process(delta: float) -> void:
	if current_node == null:
		return
		
	var bodies = platform_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player") and trigger == "player":
			activated = true
	
	if not activated:
		return
		
	var target_pos = nodes[index].global_position
	var dir = (target_pos - platform.global_position)
	var distance = dir.length()
	
	if distance < speed * delta:
		platform.global_position = target_pos
		if mode == "circular":
			index = (index + 1) % nodes.size()
		elif mode == "one-shot":
			if index < nodes.size() - 1:
				index += 1
		elif mode == "back-forth":
			index += direction
			if index >= nodes.size() or index < 0:
				direction *= -1
				index += direction * 2 
	else:
		platform.global_position += dir.normalized() * speed * delta
