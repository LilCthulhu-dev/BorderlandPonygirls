extends DefaultBtn

var index = -1
var default_pos =  Vector2.ZERO
var hover_pos = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var shortcut_key_string := ""

func _ready():
	super()
	GlobalSignals.tab_clicked.connect(on_tab_clicked)
	GlobalSignals.game_state_changed.connect(_on_game_state_changed)
	_add_shortcut()
	_add_tooltip()
	_adjust_position()
	await get_tree().physics_frame
	if index == 0:
		GlobalSignals.tab_clicked.emit(index, text)

func _add_shortcut() -> void:
	var key_event := InputEventKey.new()
	key_event.keycode = shortcut_key_string.to_upper().unicode_at(0)
	var new_shortcut := Shortcut.new()
	new_shortcut.events = [key_event]
	shortcut = new_shortcut

func _add_tooltip():
	tooltip = shortcut_key_string.to_upper()

func _adjust_position():
	await get_tree().create_timer(0.1).timeout
	default_pos = position
	hover_pos = position + Vector2(0, 5)

func _on_game_state_changed():
	disabled = GameData.game_state != Enums.GAME_STATES.MAIN

func on_tab_clicked(new_index, _titel):
	button_pressed = new_index == index

func _tween_pos(target_pos):
	var tween = create_tween()
	tween.parallel().tween_property(self, 'position', target_pos, 0.1)

func _on_pressed() -> void:
	if GameData.game_state != Enums.GAME_STATES.MAIN: return
	GlobalSignals.tab_clicked.emit(index, text)

func _on_mouse_entered() -> void:
	if GameData.game_state != Enums.GAME_STATES.MAIN: return
	_tween_pos(hover_pos)

func _on_mouse_exited() -> void:
	_tween_pos(default_pos)
