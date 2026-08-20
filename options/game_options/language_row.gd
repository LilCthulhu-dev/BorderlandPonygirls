extends HBoxContainer

@onready var lang_label: Label = %LangLabel
@onready var lang_en_btn: DefaultBtn = %LangEnBtn
@onready var lang_de_btn: DefaultBtn = %LangDeBtn


func _ready() -> void:
	_refresh()
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_refresh):
		GlobalSignals.language_changed.connect(_refresh)


func _refresh() -> void:
	if Utils:
		lang_label.text = Utils.translate("Language")
	if not Settings or not lang_en_btn or not lang_de_btn:
		return
	var is_de := Settings.is_german()
	lang_en_btn.disabled = not is_de
	lang_de_btn.disabled = is_de


func _on_lang_en_pressed() -> void:
	if Settings:
		Settings.set_language("en")


func _on_lang_de_pressed() -> void:
	if Settings:
		Settings.set_language("de")
