extends Resource
class_name Perk

enum GROUPS { NONE, TITS, TEMPER }

var name := "":
	get:
		if not resource_name.is_empty():
			return resource_name
		return resource_path.get_file().get_basename().capitalize()
var id: StringName:
	get:
		if resource_path.is_empty():
			return &""
		return StringName(resource_path.get_file().get_basename())

@export_multiline var description : String

@export var malus := Enums.ATTRIBUTES.NONE
@export var bonus := Enums.ATTRIBUTES.NONE

@export var group : GROUPS
@export var background := false

func get_bonus_descriptions(ponygirl : Ponygirl) -> Array[String]:
	var arr: Array[String] = []
	var pony_mod_bonus : = ponygirl.get_mod_bonus()
	if bonus != Enums.ATTRIBUTES.NONE:
		var attribute_name := Enums.enum_to_name(Enums.ATTRIBUTES, bonus)
		arr.append("+%s %s" % [pony_mod_bonus, attribute_name])
	if malus != Enums.ATTRIBUTES.NONE:
		var attribute_name := Enums.enum_to_name(Enums.ATTRIBUTES, malus)
		arr.append("-5 %s" % attribute_name)
	return arr

func get_full_description(ponygirl : Ponygirl) -> Array:
	var arr: Array[String] = []
	var pony_mod_bonus : = ponygirl.get_mod_bonus()
	if bonus != Enums.ATTRIBUTES.NONE:
		var attribute_name := Enums.enum_to_name(Enums.ATTRIBUTES, bonus)
		arr.append("+%s %s" % [pony_mod_bonus, attribute_name])
	if malus != Enums.ATTRIBUTES.NONE:
		var attribute_name := Enums.enum_to_name(Enums.ATTRIBUTES, malus)
		arr.append("-5 %s" % attribute_name)
	if description:
		arr.push_back(description)
	return arr
