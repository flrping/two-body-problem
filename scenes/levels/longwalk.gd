extends Node2D

var leds_layer: TextureRect
var blink_interval = 0.2;
var counter = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.get_node("Player").set_locked_camera(0, 150, false, true)
	leds_layer = self.get_node("background/leds/TextureRect")
	
	var body_list = Global.get_bodies_by_scene(get_tree().current_scene.name)
	for body_data in body_list:
		var corpse = Global.create_body_with_values(body_data.coordinates, body_data.type, body_data.sprite)
		get_tree().current_scene.add_child(corpse)
	
	Global.move_and_spawn_player(self.get_node("Player"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	counter += delta
	if counter > blink_interval:
		counter = 0
		if randfn(0.5, 0.5) > 0.6:
			leds_layer.material.set_shader_parameter("red_intensity", 1)
		else:
			leds_layer.material.set_shader_parameter("red_intensity", 0.4)
	if randfn(0.5, 0.5) > 0.7:
		blink_interval = 4
	else:
		blink_interval = 0.02
