extends AudioStreamPlayer

@onready var beeps = [
	preload("res://assets/audio/robotnoise1.wav"),
	preload("res://assets/audio/robotnoise2.wav"),
	preload("res://assets/audio/robotnoise3.wav"),
	preload("res://assets/audio/robotnoise5.wav")
]

func _on_timer_timeout() -> void:
	var parent = get_parent()
	if parent.is_alive:
		print("beep")
		stream = beeps[randi_range(0, beeps.size() - 1)]
		play()
