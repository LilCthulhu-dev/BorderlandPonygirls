extends HBoxContainer
class_name WikiBtn

@onready var buffer: Control = %Buffer
@onready var button: Button = %Button

var wiki_entry : WikiEntry
var sub_btn = false

func _ready() -> void:
	_refresh_label()
	buffer.visible = sub_btn
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_refresh_label):
		GlobalSignals.language_changed.connect(_refresh_label)


func _refresh_label() -> void:
	if button and wiki_entry:
		button.text = "> " + Utils.translate(wiki_entry.titel)

func _on_button_pressed() -> void:
	GlobalSignals.wiki_entry_selected.emit(wiki_entry)
