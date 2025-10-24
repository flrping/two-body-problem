extends Node2D

@export_multiline var text: String
var text_pos = 0

@export var normalspeed = 0.07
@export var fastspeed = 0.01
@export var ellipsisspeed = 0.6
var current_speed = normalspeed
var counter = 0

@export var delimiter := "@"

var label: RichTextLabel
var ellipsis: RichTextLabel

var wait_for_user = false

signal finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label = get_node("CanvasLayer").get_node("RichTextLabel")
	ellipsis = get_node("CanvasLayer").get_node("ellipsis")
	label.text = ""
	ellipsis.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	counter += delta
	if wait_for_user:
		if counter > ellipsisspeed:
			ellipsis.append_text(".")
			if ellipsis.get_total_character_count() > 3:
				ellipsis.text = ""
			counter = 0
		counter += delta
			
		if Input.is_action_just_pressed("ui_accept"):
			wait_for_user = false
			label.text = ""
			ellipsis.text = ""
			
	if Input.is_action_pressed("ui_accept"):
		current_speed = fastspeed
	else:
		current_speed = normalspeed
		
	if counter > current_speed and text_pos < len(text) and !wait_for_user:
		if text[text_pos] != "@":
			label.append_text(text[text_pos])
		else:
			wait_for_user = true
		
		text_pos += 1
		counter = 0
		
	if text_pos == len(text):
		if counter > ellipsisspeed:
			counter = 0
			if ellipsis.text == ".":
				ellipsis.text = ""
			else:
				ellipsis.text = "."
		
		if Input.is_action_just_pressed("ui_accept"):
			finished.emit()
				
		counter += delta
