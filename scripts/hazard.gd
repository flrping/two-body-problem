extends Area2D
class_name HazardArea2D

@export var debug = true

@export var damage: int = 0;
@onready var deathScreen = preload("res://scenes/death_screen.tscn")
@onready var sprite = $Sprite2D

signal player_died

func _ready() -> void:
	body_entered.connect(_on_area_2d_body_entered)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if !body.is_alive:
			#prevent the player from dying more than once before respawning
			return
		body.is_alive = false;
		# will change this later.
		var hazard_type = "v" if get_parent().scene_file_path.ends_with("_v.tscn") else "h"
		emit_signal("player_died", body, hazard_type)
		
		# spawns the death screen. 
		# probably should move this logic to a signal that the game itself listens to in the future.
		var exists = get_tree().current_scene.get_node_or_null("Player/Camera2D/DeathScreen")
		if exists == null:
			var _deathScreen = deathScreen.instantiate()
			_deathScreen.name = "DeathScreen"
			get_tree().current_scene.get_node("Player/Camera2D").position_smoothing_enabled = false
			get_tree().current_scene.get_node("Player/Camera2D").add_child(_deathScreen)
