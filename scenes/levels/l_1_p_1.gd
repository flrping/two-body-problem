extends Node2D

func _ready() -> void:
	get_node("Player").set_locked_camera(0, -50, false, true)
	if Global.has_died_once:
		var exit = get_node("L1P1_Exit") as Transition
		var target = "res://scenes/levels/l1_p1_open_door_again_cutscene.tscn"
		exit.target = target
		exit.targetScene = load(target)
