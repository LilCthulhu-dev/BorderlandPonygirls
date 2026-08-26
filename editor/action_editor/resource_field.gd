extends ActionField

@onready var title_label: Label = %TitleLabel
@onready var dropdown: OptionButton = %Dropdown

const RESOURCE_FOLDERS := {
	&"Item": "res://data/item/",
	&"Perk": "res://data/perks/",
}

func _ready() -> void:
	super()
	title_label.text = _get_property_title() + ": "
	dropdown.add_item("None")
	for resource in _get_options():
		var display_name := resource.resource_path.get_file().get_basename().capitalize()
		dropdown.add_item(display_name)
	var current_resource := action.get(_get_property_name()) as Resource
	dropdown.select(_get_options().find(current_resource) + 1)

func _get_required_type() -> StringName:
	return StringName(property.hint_string)

func _get_options() -> Array[Resource]:
	return _get_resources_of_type(_get_required_type())

func _get_resources_of_type(required_type: StringName) -> Array[Resource]:
	var folder_path := RESOURCE_FOLDERS.get(required_type, "") as String
	if folder_path.is_empty():
		return []
	else:
		return _find_resources(folder_path, required_type)

func _find_resources(folder_path: String, required_type: StringName) -> Array[Resource]:
	var results : Array[Resource]
	var dir := DirAccess.open(folder_path)
	dir.list_dir_begin()
	var file_name := dir.get_next()

	while not file_name.is_empty():
		if not dir.current_is_dir() and file_name.get_extension() == "tres":
			var path := folder_path.path_join(file_name)
			var resource := load(path) as Resource
			if resource != null and _is_resource_type(resource, required_type):
				results.append(resource)
		file_name = dir.get_next()

	dir.list_dir_end()
	return results

func _is_resource_type(resource: Resource, required_type: StringName) -> bool:
	var script := resource.get_script() as Script
	while script != null:
		if script.get_global_name() == required_type:
			return true
		script = script.get_base_script()
	return false

func _on_dropdown_item_selected(index: int) -> void:
	var property_name := _get_property_name()
	var options := _get_options()
	if index == 0:
		action.set(property_name, null)
	else:
		action.set(property_name, options[index - 1])
	action.emit_changed()
