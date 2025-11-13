extends Sprite2D

class_name DeadRobot

@export var sprites = []
@export var sprite = randi_range(0, sprites.size() - 1)

func change_texture(_sprite: int) -> void:
	if _sprite >= 0 and _sprite < sprites.size():
		sprite = _sprite
		texture = sprites[_sprite]
