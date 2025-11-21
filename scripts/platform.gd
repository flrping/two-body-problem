extends StaticBody2D

class_name Platform

@export var height := 1
@export var width := 3
@export var texture: Resource = null
@export var atlas_x = 0
@export var atlas_y = 0
const TILE_SIZE := 32

@onready var collision := $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.visible = false
	
	if texture == null:
		return
	
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.region_enabled = true
	sprite.region_rect = Rect2(atlas_x * TILE_SIZE, atlas_y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
	sprite.centered = false
	
	for x in width:
		for y in height:
			var dup := sprite.duplicate()
			dup.position = Vector2(TILE_SIZE * x, TILE_SIZE * y)
			add_child(dup)
	
	var rect := collision.shape as RectangleShape2D
	rect.size = Vector2(width * TILE_SIZE, height * TILE_SIZE)
	
	collision.position = rect.size / 2
	print(rect.size)
