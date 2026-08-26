extends ActionField

@onready var check_box: CheckBox = %CheckBox

func _ready() -> void:
	super()
	check_box.text = _get_property_title()
	check_box.button_pressed = action.get(_get_property_name())

func _on_check_box_toggled(value: bool) -> void:
	action.set(_get_property_name(), value)
	action.emit_changed()
