extends Resource
class_name Item

@export var title := ""
var id := "":
	get:
		return Utils.string_to_id(title)
@export var price := 0
@export var weight : int = 1
@export var icon : Texture2D
@export var amount = 1
