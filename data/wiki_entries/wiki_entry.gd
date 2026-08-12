extends Resource
class_name WikiEntry

@export var titel : String:
	get:
		if titel != "": return titel
		return resource_path.get_file().get_basename().capitalize()
@export var sub_entries : Array[WikiEntry]
@export_multiline var description : String
@export var img : Texture2D
