extends TextureRect

var amplitude = 10.0
var speed = 2.0
var base_y = 0.0
var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_y = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta * speed
	position.y = base_y + sin(time) * amplitude
