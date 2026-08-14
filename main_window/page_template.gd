extends Control
class_name StoryPage

@export var btn_text = "???"
@export var shortcut_key_string := ""
var index = -1
var active = false

func _ready() -> void:
	GlobalSignals.tab_clicked.connect(on_tab_clicked)
	if Utils:
		Utils.localize_tree(self)
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_on_language_changed):
		GlobalSignals.language_changed.connect(_on_language_changed)


func _on_language_changed() -> void:
	if Utils:
		Utils.localize_tree(self)

func on_tab_clicked(new_index, _titel):
	if new_index == index:
		_on()
	else:
		_off()

func _on():
	active = true

func _off():
	if not active: return
	active = false
