extends HBoxContainer
class_name WikiBtn

@onready var buffer: Control = %Buffer
@onready var button: Button = %Button

var wiki_entry : WikiEntry
var sub_btn = false

func _ready() -> void:
	button.text = "> " + wiki_entry.titel
	buffer.visible = sub_btn

func _on_button_pressed() -> void:
	GlobalSignals.wiki_entry_selected.emit(wiki_entry)
