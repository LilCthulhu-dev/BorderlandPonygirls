extends HBoxContainer

@onready var sound_label: Label = %SoundLabel
@onready var sound_slider: HSlider = %SoundSlider
@export var bus_name: String
var bus_index : int

func _ready() -> void:
	_apply_label()
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_apply_label):
		GlobalSignals.language_changed.connect(_apply_label)
	bus_index = AudioServer.get_bus_index(bus_name)
	sound_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index))


func _apply_label() -> void:
	sound_label.text = Utils.translate(bus_name) if Utils else bus_name

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index, linear_to_db(value))
