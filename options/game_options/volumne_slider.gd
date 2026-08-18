extends HBoxContainer

@onready var sound_label: Label = %SoundLabel
@onready var sound_slider: HSlider = %SoundSlider
@export var bus_name: String
var bus_index : int

func _ready() -> void:
	sound_label.text = bus_name
	bus_index = AudioServer.get_bus_index(bus_name)
	sound_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index))

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index, linear_to_db(value))
