# Usage: This object is 1x1 pixels, please scale the entire object rather than cloning it
# Use UI to change the "target" parameter to the desired scene

extends Node2D
@export var target: String = "";
@export var cutscene: String = "";

var targetScene: PackedScene = null;

signal trigger_switch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetScene = load(target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	#apparently altering the scene tree in a physics callback can cause issues
	trigger_switch.emit()

func _on_trigger_switch():
	if cutscene.length() > 0:
		var scene = Control.new()
		var player = VideoStreamPlayer.new()
		var stream = VideoStreamTheora.new()
		stream.file = cutscene
		player.stream = stream
		player.expand = true
		player.loop = false
		player.size = get_viewport_rect().size
		player.position = Vector2.ZERO
		scene.add_child(player)
		
		var old = get_tree().current_scene
		get_tree().root.add_child(scene)
		get_tree().current_scene = scene
		old.queue_free()
		
		print("Started playing")
		player.play()
		await player.finished
		print("Finished playing")
		
	get_tree().call_deferred("change_scene_to_packed", targetScene)
