extends CanvasLayer
class_name Modal

@onready var content_container: Control = %ContentContainer
const ANIMATION_DURATION = 0.3
var is_closing := false
var screen_width : Vector2
var pos_start : Vector2
var pos_end : Vector2
var pos_active := Vector2.ZERO
var close_on_background_click := true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	screen_width = get_viewport().get_visible_rect().size
	pos_start = Vector2(-screen_width.x, 0.0)
	pos_end = Vector2(screen_width.x, 0.0)
	open()

func open():
	content_container.position = pos_start
	await _move_content(pos_active)

func close() -> void:
	if is_closing:
		return
	is_closing = true
	await _move_content(pos_end, Tween.EASE_IN)
	await get_tree().create_timer(0.1).timeout
	queue_free()
	await tree_exited

func _move_content(target_pos : Vector2, ease_type := Tween.EASE_OUT):
	var t := create_tween()
	t.set_trans(Tween.TRANS_BACK)
	t.set_ease(ease_type)
	t.tween_property(
		content_container,
		'position',
		target_pos,
		ANIMATION_DURATION
	)
	await t.finished
