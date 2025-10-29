extends Node

@onready var corpse_h = preload("res://scenes/objects/dead_robot_h.tscn")
@onready var corpse_v = preload("res://scenes/objects/dead_robot_v.tscn")

# key scene, value array of coordinates
var bodies: Dictionary = {}
var spawn_id: String = ""

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
	
func move_and_spawn_player(player: Node2D):
	var spawn: Node2D
	if spawn_id.length() > 0:
		var node = get_tree().current_scene.get_node_or_null(spawn_id)
		if node != null:
			spawn = node
	if spawn == null:
		spawn = get_tree().current_scene.get_node("Spawn")

	var to: Node2D = get_tree().current_scene.get_node_or_null(spawn.name + "/To")
	if to == null:
		player.position = spawn.position
	else: 
		player.position = to.global_position
