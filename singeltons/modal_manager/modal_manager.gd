extends CanvasLayer

const CARE_MODAL = preload("uid://dkclnrgmlsj6m")
const CARE_RESULT_MODAL = preload("uid://dst8n1tcmvat1")
const COMBAT_RESULT_MODAL = preload("uid://lqj1gkl1ug7q")
const EVENT_RESULT_MODAL = preload("uid://c1nein15t5qxa")
const GAME_OVER_MODAL = preload("uid://c0vk0v4thw6ao")
const LOCATION_RESULT_MODAL = preload("uid://8utfmm5jg16r")
const PONYGIRL_MODAL = preload("uid://dtb1ip2vbvogd")
const ANIMATION_DURATION = 0.3

@onready var background: ColorRect = $Background
@onready var background_btn: Button = $BackgroundBtn

var modal: Modal = null
var old_game_state = null
var replacing_modal := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	background.modulate.a = 0.0
	background_btn.disabled = true

# ================================================== specific modals
func open_game_over_modal():
	return await _open_modal(GAME_OVER_MODAL)

func open_loaction_result_modal(results : Array[String]):
	return await _open_modal(LOCATION_RESULT_MODAL, {"results": results})

func open_event_result_modal(actions : Array[Action], extra_text := "") -> Modal:
	return await _open_modal(EVENT_RESULT_MODAL, {
		"extra_text": extra_text,
		"actions": actions})

func open_combat_result_modal(action : CombatAction) -> Modal:
	return await _open_modal(COMBAT_RESULT_MODAL, {"action": action})

func open_care_modal(ponygirl : Ponygirl) -> Modal:
	return await _open_modal(CARE_MODAL, {"ponygirl": ponygirl})

func open_care_result_modal(actions: Array[Action]) -> Modal:
	return await _open_modal(CARE_RESULT_MODAL, {"actions": actions})

func open_ponygirl_modal(ponygirl: Ponygirl) -> Modal:
	return await _open_modal(PONYGIRL_MODAL, {"ponygirl": ponygirl})

# ================================================== open / close logic
func _open_modal(modal_bp : PackedScene, properties: Dictionary = {}) -> Modal:
	if modal == null:
		old_game_state = GameData.game_state
		GameData.game_state = Enums.GAME_STATES.MODAL
		get_tree().paused = true
		background_btn.disabled = false
		background_btn.mouse_filter = Control.MOUSE_FILTER_STOP
		_fade_background(1.0)
	else:
		replacing_modal = true
		await modal.close()
	TooltipManager.remove()
	var m := modal_bp.instantiate() as Modal
	for property in properties:
		m.set(property, properties[property])
	get_tree().current_scene.add_child(m)

	modal = m
	modal.tree_exited.connect(_on_tree_exited.bind(m))
	replacing_modal = false

	return modal

func _on_tree_exited(m: Modal) -> void:
	if modal != m:
		return
	modal = null
	if replacing_modal:
		return
	var tree := get_tree()
	if tree == null:
		return
	_fade_background(0.0)
	background_btn.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background_btn.disabled = true
	if old_game_state != null:
		GameData.game_state = old_game_state
	old_game_state = null
	tree.paused = false

func close_current_modal():
	if modal == null:
		return
	modal.close()

# ================================================== background
func _fade_background(target_alpha: float) -> void:
	var t := create_tween()
	t.tween_property(
		background,
		"modulate:a",
		target_alpha,
		ANIMATION_DURATION
	)
	await t.finished

func _on_background_btn_pressed() -> void:
	if modal == null:
		return
	if modal.close_on_background_click:
		close_current_modal()
