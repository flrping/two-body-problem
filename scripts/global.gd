extends Node

@onready var corpse_h = preload("res://scenes/objects/dead_robot_h.tscn")
@onready var corpse_v = preload("res://scenes/objects/dead_robot_v.tscn")

# key scene, value array of coordinates
var bodies = {}

# Creates a body node.
func create_body(coordinates: Vector2, type: String) -> Node: 
	var _corpse
	if type == "h":
		_corpse = corpse_h.instantiate()
	else:
		_corpse = corpse_v.instantiate()
	_corpse.position = coordinates
	print(type)
	return _corpse

# Creates a body node.
func create_body_with_values(coordinates: Vector2, type: String, sprite: int) -> Node: 
	var _corpse
	if type == "h":
		_corpse = corpse_h.instantiate()
	else:
		_corpse = corpse_v.instantiate()
	_corpse.position = coordinates
	_corpse.change_texture(sprite)
	return _corpse

# Adds body to dict
func add_body(scene: String, coordinates: Vector2, type: String, sprite: int) -> void:
	if not bodies.has(scene):
		bodies[scene] = []
	bodies[scene].append({
		"coordinates": coordinates,
		"type": type,
		"sprite": sprite
	})

# Gets all bodies
func get_bodies() -> Dictionary:
	return bodies
	
# Gets all bodies for a specific scene
func get_bodies_by_scene(scene: String) -> Array:
	return bodies.get(scene, [])
	
