extends Polygon2D

var rng = RandomNumberGenerator.new()
@export var flip = true

func _ready() -> void:
	if !flip: return
	rng.randomize()
	if rng.randi_range(0, 1) == 1:
		scale.x = 1.0
	if rng.randi_range(0, 1) == 1:
		scale.x = -1.0
