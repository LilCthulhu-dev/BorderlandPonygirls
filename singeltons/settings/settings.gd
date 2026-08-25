extends Node

const PATH := "user://settings.cfg"
const BUSES := ["Master", "SFX", "Music"]

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
	if cfg.load(PATH) != OK:
		return
	for bus_name in BUSES:
		var idx := AudioServer.get_bus_index(bus_name)
		if idx < 0:
			continue
		var linear: float = cfg.get_value("audio", bus_name, 1.0)
		AudioServer.set_bus_volume_db(idx, linear_to_db(clampf(linear, 0.0, 1.0)))

func _save() -> void:
	var cfg := ConfigFile.new()
	cfg.load(PATH)
	for bus_name in BUSES:
		var idx := AudioServer.get_bus_index(bus_name)
		if idx < 0:
			continue
		cfg.set_value("audio", bus_name, db_to_linear(AudioServer.get_bus_volume_db(idx)))
	cfg.save(PATH)
