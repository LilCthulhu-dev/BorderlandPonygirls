extends Sprite2D

func _ready() -> void:
	if Utils.rng.randi_range(0, 1) == 1:
		scale.x *= -1
