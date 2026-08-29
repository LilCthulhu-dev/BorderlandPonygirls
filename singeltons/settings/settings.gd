extends Node

## User preferences (persisted under user://settings.cfg).

const CONFIG_PATH := "user://settings.cfg"
const SECTION_DISPLAY := "display"
const SECTION_AUDIO := "audio"
const BUSES := ["Master", "SFX", "Music"]

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


func get_bus_linear(bus_name: String) -> float:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx < 0:
		return 1.0
	return db_to_linear(AudioServer.get_bus_volume_db(idx))


func set_bus_linear(bus_name: String, linear: float, persist := true) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx < 0:
		return
	AudioServer.set_bus_volume_db(idx, linear_to_db(clampf(linear, 0.0, 1.0)))
	if persist:
		_save()


func _load() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(CONFIG_PATH) != OK:
		return
	_loading = true
	language = str(cfg.get_value(SECTION_DISPLAY, "language", "en"))
	if language != "en" and language != "de":
		language = "en"
	_loading = false
	for bus_name in BUSES:
		var idx := AudioServer.get_bus_index(bus_name)
		if idx < 0:
			continue
		var linear: float = cfg.get_value(SECTION_AUDIO, bus_name, 1.0)
		AudioServer.set_bus_volume_db(idx, linear_to_db(clampf(linear, 0.0, 1.0)))


func _save() -> void:
	var cfg := ConfigFile.new()
	cfg.load(CONFIG_PATH)
	cfg.set_value(SECTION_DISPLAY, "language", language)
	for bus_name in BUSES:
		var idx := AudioServer.get_bus_index(bus_name)
		if idx < 0:
			continue
		cfg.set_value(SECTION_AUDIO, bus_name, db_to_linear(AudioServer.get_bus_volume_db(idx)))
	cfg.save(CONFIG_PATH)


func set_language(lang: String) -> void:
	language = lang


func is_german() -> bool:
	return language == "de"
