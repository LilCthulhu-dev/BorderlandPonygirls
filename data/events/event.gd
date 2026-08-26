extends Resource
class_name Event

@export var titel : String
@export var sub_folder : String
@export var _id: StringName
var id: StringName:
	get:
		if _id == "":
			return resource_path.get_file().get_basename()
		else:
			return _id
@export_multiline var description : String:
	get:
		return Utils.translate(description)
@export var img : Texture2D
@export var content : Array[_EventContent]
@export var open_actions : Array[Action]
@export var close_actions : Array[Action]

func requirements_are_met() -> bool:
	for action in open_actions:
		if not action.requirement_met():
			return false
	return true

func open() -> void:
	for action in open_actions:
		action.use()

func close() -> void:
	for action in close_actions:
		action.use()
	for c in content:
		if c is EventCheck:
			c.reset()
		if c is EventBtn:
			c.reset()
