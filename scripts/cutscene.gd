extends VideoStreamPlayer

@export var cutscenePath: String = "";
@export var nextScenePath: String = "";

var nextScene: PackedScene = null;

func _ready() -> void:
	nextScene = load(nextScenePath)
	var _stream = VideoStreamTheora.new()
	_stream.file = cutscenePath
	stream = _stream
	size = get_viewport_rect().size
	position = Vector2.ZERO
	play()

func _on_finished() -> void:
	get_tree().call_deferred("change_scene_to_packed", nextScene)
