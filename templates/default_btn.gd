extends Button
class_name DefaultBtn

@export var hover_sound := "hover"
@export var click_sound := "click"
@export var add_tooltip_icon = false
@export var show_tooltip_if_disabled = false
@export_multiline var tooltip := ""

var questionmark = preload("res://assets/icons/questionmark.png")

func _ready() -> void:
	mouse_entered.connect(basic_hover)
	mouse_exited.connect(basic_hover_stop)
	pressed.connect(basic_click)
	text = Utils.translate(text)
	if add_tooltip_icon:
		add_questionmark()

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
