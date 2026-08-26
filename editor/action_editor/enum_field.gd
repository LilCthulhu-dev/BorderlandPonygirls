extends ActionField

@onready var label: Label = %Label
@onready var dropdown: OptionButton = %Dropdown

func _ready() -> void:
	super()
	label.text = _get_property_title() + ": "
	var options := String(property.hint_string).split(",")
	for option in options:
		var parts := option.split(":")
		var option_name := parts[0].capitalize()
		var option_value := int(parts[1])
		dropdown.add_item(option_name, option_value)
	var current_value := int(action.get(_get_property_name()))
	dropdown.select(dropdown.get_item_index(current_value))

func _on_dropdown_item_selected(index: int) -> void:
	var enum_value := dropdown.get_item_id(index)
	action.set(_get_property_name(), enum_value)
	action.emit_changed()
