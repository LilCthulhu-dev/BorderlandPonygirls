extends CanvasLayer

const CONTENT_START_POSITION := Vector2(-1152.0, 0.0)
const CONTENT_END_POSITION := Vector2.ZERO
const CONTENT_EXIT_POSITION := Vector2(1152.0, 0.0)
const TWEEN_TIME := 0.35

@onready var content: Control = %Content
@onready var save_btn: DefaultBtn = %SaveBtn
@onready var close_btn: DefaultBtn = %CloseBtn
@onready var lang_label: Label = %LangLabel
@onready var lang_en_btn: DefaultBtn = %LangEnBtn
@onready var lang_de_btn: DefaultBtn = %LangDeBtn

@onready var sub_menues: Control = %SubMenues
@onready var new_game: Control = %NewGame
@onready var save_load: Control = %SaveLoad
@onready var credits: Control = %Credits

func _ready() -> void:
	_hide_options()
	var is_start_menu = GameData.game_state == Enums.GAME_STATES.START
	close_btn.visible = !is_start_menu
	if not is_start_menu:
		animation(true)
	get_tree().paused = true
	if GameData.game_state != Enums.GAME_STATES.START:
		GameData.game_state = Enums.GAME_STATES.OPTIONS
	_refresh_language_ui()
	if lang_en_btn and not lang_en_btn.pressed.is_connected(_on_lang_en_pressed):
		lang_en_btn.pressed.connect(_on_lang_en_pressed)
	if lang_de_btn and not lang_de_btn.pressed.is_connected(_on_lang_de_pressed):
		lang_de_btn.pressed.connect(_on_lang_de_pressed)
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_refresh_language_ui):
		GlobalSignals.language_changed.connect(_refresh_language_ui)


func _on_lang_en_pressed() -> void:
	if Settings:
		Settings.set_language("en")


func _on_lang_de_pressed() -> void:
	if Settings:
		Settings.set_language("de")


func _refresh_language_ui() -> void:
	if Utils:
		Utils.localize_tree(self)
	if lang_label and Utils:
		lang_label.text = Utils.translate("Language")
	if not lang_en_btn or not lang_de_btn or not Settings:
		return
	var is_de := Settings.is_german()
	lang_en_btn.disabled = not is_de
	lang_de_btn.disabled = is_de

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if not event.pressed or event.echo:
		return
	if event.keycode != KEY_ESCAPE:
		return
	if not close_btn.visible:
		return
	get_viewport().set_input_as_handled()
	_close()

func _close() -> void:
	await animation(false)
	get_tree().paused = false
	GameData.game_state = GameData.old_game_state
	queue_free()

func _hide_options():
	for child in sub_menues.get_children():
		child.visible = false

# =================================================== Animation
func animation(opening: bool) -> void:
	var tween := create_tween()
	var target_position := CONTENT_END_POSITION if opening else CONTENT_EXIT_POSITION
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT if opening else Tween.EASE_IN)
	if opening:
		content.position = CONTENT_START_POSITION
	tween.tween_property(
		content,
		"position",
		target_position,
		TWEEN_TIME
	)
	await tween.finished

func _fade_in(menu: Control) -> void:
	_hide_options()

	menu.modulate = Color("#ffffff00")
	menu.visible = true
	if Utils:
		Utils.localize_tree(menu)

	var tween := create_tween()
	tween.tween_property(
		menu,
		"modulate",
		Color.WHITE,
		0.3
	)

# =================================================== btns
func _on_new_game_btn_pressed() -> void:
	_hide_options()
	_fade_in(new_game)

func _on_save_btn_pressed() -> void:
	_hide_options()
	_fade_in(save_load)

func _on_credits_btn_pressed() -> void:
	_hide_options()
	_fade_in(credits)

func _on_close_btn_pressed() -> void:
	_close()
