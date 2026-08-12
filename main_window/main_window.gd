extends CanvasLayer

const TAB_BTN = preload("uid://c2ujkab6mm8br")
const OPTIONS = preload("uid://grvg54i0pqei")

@onready var pages: HBoxContainer = %Pages
@onready var tabs: HBoxContainer = %Tabs

@export var page_width := 1152.0
@export var page_height := 648.0
var current_index := 0
var page_tween: Tween

func _ready():
	GlobalSignals.tab_clicked.connect(on_tab_clicked)
	GameData.game_state = Enums.GAME_STATES.MAIN
	_add_tab_btn()

func _input(event: InputEvent) -> void:
	if GameData.game_state != Enums.GAME_STATES.MAIN:
		return
	if not event is InputEventKey:
		return
	if not event.pressed or event.echo:
		return
	if event.keycode == KEY_ESCAPE:
		_open_options()
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_TAB:
		_switch_tab(event.shift_pressed)
		get_viewport().set_input_as_handled()

func _open_options() -> void:
	var options := OPTIONS.instantiate()
	get_tree().current_scene.add_child(options)

func _switch_tab(backwards: bool) -> void:
	var tab_count := tabs.get_child_count()
	if tab_count == 0:
		return
	var direction := -1 if backwards else 1
	var target_index := wrapi(current_index + direction, 0, tab_count)
	var target_tab := tabs.get_child(target_index) as Button
	target_tab.pressed.emit()

func _add_tab_btn():
	var index = 0
	for page in pages.get_children():
		if page is not StoryPage: continue
		page.index = index
		var btn = TAB_BTN.instantiate()
		btn.text = page.btn_text
		btn.shortcut_key_string = page.shortcut_key_string
		btn.index = index
		tabs.add_child(btn)
		index += 1

func on_tab_clicked(target_index: int, _titel) -> void:
	if target_index == current_index:
		return
	if page_tween and page_tween.is_valid():
		page_tween.kill()
	var target_vector := Vector2(target_index * page_width * -1, 0.0)
	var distance : int = abs(pages.position.x - target_vector.x)
	var tween_time : float = distance / page_width * 0.2
	current_index = target_index
	page_tween = create_tween()
	page_tween.set_trans(Tween.TRANS_SINE)
	page_tween.set_ease(Tween.EASE_IN_OUT)
	page_tween.tween_property(
		pages,
		"position",
		target_vector,
		tween_time
	)
