@tool
extends Resource
class_name Item

@export var title := ""
var id := "":
	get:
		return Utils.string_to_id(title)
@export var price := 0
@export var weight : int = 5
@export var icon : Texture2D
@export var amount = 1

@export_tool_button("Set Title From Filename")
var set_title_button := set_title_from_filename

func set_title_from_filename() -> void:
	if resource_path.is_empty():
		push_warning("Item must be saved as a .tres file first.")
		return
	title = resource_path.get_file().get_basename().capitalize()
