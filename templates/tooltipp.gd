extends Node2D
class_name Tooltip

@onready var label: Label = %Label
var txt = ""
var wait_time = 0.5

func _ready() -> void:
	modulate = Color("ffffff00")
	label.text = txt
	_fade_in()
	await get_tree().create_timer(wait_time).timeout
	label.position.x = -label.size.x / 2

func _fade_in() -> void:
	await get_tree().create_timer(wait_time).timeout
	create_tween().tween_property(self, 'modulate', Color("White"), 0.2)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	if global_position.y <= 648.0 / 2:
		var pos = 30
		if label.position.y == pos: return
		label.position.y = pos
	else:
		var pos = -(label.size.y + 10)
		if label.position.y == pos: return
		label.position.y = pos
