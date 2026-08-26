extends ActionField

@onready var title_label: Label = %TitleLabel
@onready var number_box: SpinBox = %NumberBox

func _ready() -> void:
	super()
	title_label.text = _get_property_title() + ": "
	number_box.min_value = -999999
	number_box.max_value = 999999
	number_box.step = 1.0 if _is_integer() else 0.1
	number_box.value = action.get(_get_property_name())
	number_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func _is_integer() -> bool:
	return int(property.type) == TYPE_INT

func _on_number_box_value_changed(value: float) -> void:
	if _is_integer():
		action.set(_get_property_name(), int(value))
	else:
		action.set(_get_property_name(), value)
	action.emit_changed()
