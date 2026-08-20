extends Node

## User preferences (persisted under user://settings.cfg).

const CONFIG_PATH := "user://settings.cfg"
const SECTION := "display"

var _loading := false

## "en" | "de"
var language: String = "en":
	set(value):
		if value != "en" and value != "de":
			value = "en"
		if language == value:
			return
		language = value
		if _loading:
			return
		_save()
		if GlobalSignals:
			GlobalSignals.language_changed.emit()
			GlobalSignals.update_ponygirls.emit()
			GlobalSignals.update_location.emit()
			GlobalSignals.update_event.emit()
			GlobalSignals.update_attribute.emit()
			GlobalSignals.update_inventory.emit()


func _ready() -> void:
	_load()


func _load() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(CONFIG_PATH) != OK:
		return
	_loading = true
	language = str(cfg.get_value(SECTION, "language", "en"))
	if language != "en" and language != "de":
		language = "en"
	_loading = false


func _save() -> void:
	var cfg := ConfigFile.new()
	cfg.load(CONFIG_PATH)
	cfg.set_value(SECTION, "language", language)
	cfg.save(CONFIG_PATH)


func set_language(lang: String) -> void:
	language = lang


func is_german() -> bool:
	return language == "de"
