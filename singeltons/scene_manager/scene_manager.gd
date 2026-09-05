extends CanvasLayer

@onready var background: ColorRect = %Background

const START_MENU = preload("uid://grvg54i0pqei")
const MAIN_WINDOW = preload("res://main_window/main_window.tscn")
const EVENT__WINDOW = preload("uid://dtc5bf8lca3ta")
const COMBAT_WINDOW = preload("uid://q2vd1if8ju13")

var fade_time := 0.2
var fade_color := Color("090a14")
var clear_color := Color("0a0a1400")

func _ready() -> void:
	background.modulate = clear_color

func change_scene(new_scene: PackedScene) -> void:
	GameData.game_state = Enums.GAME_STATES.SCENE_CHANGE
	get_tree().paused = true
	await _tween_background(fade_color)

	get_tree().change_scene_to_packed(new_scene)
	await get_tree().scene_changed

	await _tween_background(clear_color)
	get_tree().paused = false
	await get_tree().create_timer(0.1).timeout

func _tween_background(target_value: Color) -> void:
	var tween := create_tween()
	tween.tween_property(background, "modulate", target_value, fade_time)
	await tween.finished
