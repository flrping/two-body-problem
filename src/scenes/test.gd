extends Node2D

var textbox_preload = preload("res://scenes/text-display.tscn")
var textbox: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textbox = textbox_preload.instantiate()
	add_child(textbox)
	textbox.text = "Textbox?\nmore like testbox!!@Have a good test!"
	textbox.connect("finished", dialog_over)
	get_tree().paused = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func dialog_over():
	get_tree().paused = false
	textbox.queue_free()
