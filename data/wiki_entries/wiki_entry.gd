extends Resource
class_name WikiEntry

var titel : String:
	get:
		return resource_path.get_file().get_basename().capitalize()
@export var sub_entries : Array[WikiEntry]
@export_multiline var description : String
@export var img : Texture2D
