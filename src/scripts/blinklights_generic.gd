extends TileMapLayer

var leds_layer: TextureRect
var blink_interval = 0.2;
var counter = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#leds_layer = self.get_node("background/blinkylights")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	counter += delta
	if counter > blink_interval:
		counter = 0
		if randfn(0.5, 0.5) > 0.6:
			self.material.set_shader_parameter("red_intensity", 1)
		else:
			self.material.set_shader_parameter("red_intensity", 0.4)
	if randfn(0.5, 0.5) > 0.7:
		blink_interval = 4
	else:
		blink_interval = 0.02
