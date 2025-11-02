extends Area2D
class_name HazardArea2D

signal player_died(body: Node2D, hazard_name: String)

@export var hazard_name: String = "UnknownHazard"
@export var death_screen_scene: PackedScene

func _ready() -> void:
	add_to_group("Hazards")
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	if not body.is_alive:
		return
	
	body.is_alive = false
	emit_signal("player_died", body, hazard_name)
	
	_spawn_death_screen(body)

func _spawn_death_screen(player: Node2D) -> void:
	var cam := player.get_node_or_null("Camera2D")
	if cam == null:
		return

	cam.position_smoothing_enabled = false
	if cam.get_node_or_null("DeathScreen") == null and death_screen_scene:
		var ds = death_screen_scene.instantiate()
		ds.name = "DeathScreen"
		cam.add_child(ds)
