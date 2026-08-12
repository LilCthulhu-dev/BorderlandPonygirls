extends Resource
class_name Flag

var id: StringName:
	get:
		return StringName(resource_path.get_file().get_basename())
@export var image : Texture2D
@export_multiline var description = ""
