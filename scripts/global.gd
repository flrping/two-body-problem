extends Node

@onready var corpse = preload("res://scenes/objects/dead_robot.tscn")

# key scene, value array of coordinates
var bodies = {}

# Creates a body node.
func create_body(coordinates: Vector2) -> Node: 
	var _corpse = corpse.instantiate()
	_corpse.position = coordinates
	return _corpse

# Creates a body node.
func create_body_with_type(coordinates: Vector2, type: int) -> Node: 
	var _corpse = corpse.instantiate()
	_corpse.position = coordinates
	_corpse.change_texture(type)
	return _corpse

# Adds body to dict
func add_body(scene: String, coordinates: Vector2, body_type: int = 0) -> void:
	if not bodies.has(scene):
		bodies[scene] = []
	bodies[scene].append({
		"coordinates": coordinates,
		"type": body_type,
	})

# Gets all bodies
func get_bodies() -> Dictionary:
	return bodies
	
# Gets all bodies for a specific scene
func get_bodies_by_scene(scene: String) -> Array:
	return bodies.get(scene, [])
	
