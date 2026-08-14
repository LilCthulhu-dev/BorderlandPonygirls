extends Button
class_name DefaultBtn

@export var hover_sound := "hover"
@export var click_sound := "click"
@export var add_tooltip_icon = false
@export var show_tooltip_if_disabled = false
@export_multiline var tooltip := ""

## English source label (set once from editor text) for re-localization.
var _source_text: String = ""
var _source_tooltip: String = ""

var questionmark = preload("res://assets/icons/questionmark.png")

func _ready() -> void:
	mouse_entered.connect(basic_hover)
	mouse_exited.connect(basic_hover_stop)
	pressed.connect(basic_click)
	if _source_text.is_empty():
		_source_text = text
	if _source_tooltip.is_empty():
		_source_tooltip = tooltip
	_apply_locale()
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_apply_locale):
		GlobalSignals.language_changed.connect(_apply_locale)
	if add_tooltip_icon:
		add_questionmark()


func _apply_locale() -> void:
	if Utils:
		text = Utils.translate(_source_text)
		if not _source_tooltip.is_empty():
			tooltip = Utils.translate(_source_tooltip)


## Set English source label and refresh display.
func set_source_text(src: String) -> void:
	_source_text = src
	_apply_locale()

func add_icon(new_icon):
	icon_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	expand_icon = true
	icon = new_icon

func add_questionmark():
	add_icon(questionmark)

func basic_hover():
	if disabled && !show_tooltip_if_disabled: return
	if tooltip != "":
		TooltipManager.add(tooltip)
	if hover_sound:
		AudioManager.play(hover_sound, 0.1, -15.0)

func basic_hover_stop():
	if tooltip != "":
		TooltipManager.remove()

func basic_click():
	if click_sound:
		AudioManager.play(click_sound, 0.0)
