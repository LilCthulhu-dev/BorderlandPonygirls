extends HBoxContainer

@onready var sound_label: Label = %SoundLabel
@onready var sound_slider: HSlider = %SoundSlider
@export var bus_name: String
var _readying := true

func _ready() -> void:
	sound_label.text = bus_name
	sound_slider.value = Settings.get_bus_linear(bus_name)
	_readying = false

func _on_h_slider_value_changed(value: float) -> void:
	if _readying:
		return
	Settings.set_bus_linear(bus_name, value)
