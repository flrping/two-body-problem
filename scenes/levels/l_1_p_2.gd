extends Node2D

var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("Player")
	player.disable_inputs_until_landed()
	
	var body_list = Global.get_bodies_by_scene(get_tree().current_scene.name)
	for body_data in body_list:
		var corpse = Global.create_body_with_type(body_data.coordinates, body_data.type)
		get_tree().current_scene.add_child(corpse)
		
	pass # Replace with function body.

func _on_player_has_died(corpse) -> void:
	Global.add_body(get_tree().current_scene.name, corpse.position, corpse.type)
	get_tree().current_scene.add_child(corpse)
