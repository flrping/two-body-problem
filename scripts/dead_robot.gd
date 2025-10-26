extends Sprite2D

@onready var sprites = [
	preload("res://assets/Dead1.png"),
	preload("res://assets/Dead2.png"),
	preload("res://assets/Dead3.png")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = sprites[randi_range(0, sprites.size() - 1)]
