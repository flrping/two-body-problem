extends Area2D
class_name HazardArea2D

@export var debug = true

@export var damage: int = 0;
@onready var deathScreen = load("res://scenes/death_screen.tscn")

func _ready() -> void:
	body_entered.connect(_on_area_2d_body_entered)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if !body.is_alive:
			#prevent the player from dying more than once before respawning
			return
		print("hazard")
		body.is_alive = false;
		
		# spawns the death screen. 
		# probably should move this logic to a signal that the game itself listens to in the future.
		var exists = get_tree().current_scene.get_node_or_null("Player/Camera2D/DeathScreen")
		if exists == null:
			var _deathScreen = deathScreen.instantiate()
			_deathScreen.name = "DeathScreen"
			get_tree().current_scene.get_node("Player/Camera2D").position_smoothing_enabled = false
			get_tree().current_scene.get_node("Player/Camera2D").add_child(_deathScreen)
