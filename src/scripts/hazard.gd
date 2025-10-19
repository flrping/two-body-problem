extends Area2D
class_name HazardArea2D

@export var damage: int = 0;

func _ready() -> void:
	body_entered.connect(_on_area_2d_body_entered)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# add player death stuff here.
		return
