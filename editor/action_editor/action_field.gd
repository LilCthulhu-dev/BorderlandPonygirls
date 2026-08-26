extends HBoxContainer
class_name ActionField

var action : Action
var property : Dictionary

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

func setup(new_action: Action, new_property: Dictionary) -> void:
	action = new_action
	property = new_property
	if get_child_count() >= 1:
		var field := get_child(0) as Control
		if field != null:
			field.custom_minimum_size.x = 150

func _get_property_name() -> StringName:
	return property["name"] as StringName

func _get_property_title() -> String:
	return String(_get_property_name()).capitalize()

func _set_value(new_value) -> void:
	action.set(_get_property_name(), new_value)
