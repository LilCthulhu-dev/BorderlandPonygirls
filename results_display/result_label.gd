extends Label

@export var stay_time := 5.0
@export var fade_in_time := 0.5
@export var fade_out_time := 1.0

func _ready() -> void:
	modulate.a = 0.0

	var fade_in = create_tween()
	fade_in.tween_property(self, "modulate:a", 1.0, fade_in_time)
	await fade_in.finished

	await get_tree().create_timer(stay_time).timeout

	var fade_out = create_tween()
	fade_out.tween_property(self, "modulate:a", 0.0, fade_out_time)
	await fade_out.finished

	queue_free()
