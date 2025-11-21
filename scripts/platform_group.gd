extends Node2D

class_name PlatformGroup

# pixels per second
@export var speed := 30.0
@export var current_node = null
@export var nodes: Array[Node2D] = []
@export var index = 0
@export var mode := "circular"
var modes = ["circular", "one-shot", "back-forth"]
var direction := 1 

@onready var platform = $Platform as Platform

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		if node.name.begins_with("Point_"):
			nodes.append(node)
	
	nodes.sort()
	if nodes.size() > 0 and nodes.size() > index:
		current_node = nodes[index]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_node == null:
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
