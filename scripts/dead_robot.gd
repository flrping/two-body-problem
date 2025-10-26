extends Sprite2D

const SPRITES = [
	preload("res://assets/Dead1.png"),
	preload("res://assets/Dead2.png"),
	preload("res://assets/Dead3.png")
]

@export var type = randi_range(0, SPRITES.size() - 1)

func _ready() -> void:
	texture = SPRITES[type]

func change_texture(_type: int) -> void:
	if _type >= 0 and _type < SPRITES.size():
		type = _type
		texture = SPRITES[_type]
