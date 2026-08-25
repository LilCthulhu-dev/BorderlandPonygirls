extends HBoxContainer

@onready var sound_label: Label = %SoundLabel
@onready var sound_slider: HSlider = %SoundSlider
@export var bus_name: String
var _readying := true

func _ready() -> void:
	_apply_label()
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_apply_label):
		GlobalSignals.language_changed.connect(_apply_label)
	sound_slider.value = Settings.get_bus_linear(bus_name)
	_readying = false


func _apply_label() -> void:
	sound_label.text = Utils.translate(bus_name) if Utils else bus_name

func _on_h_slider_value_changed(value: float) -> void:
	if _readying:
		return
	Settings.set_bus_linear(bus_name, value)
