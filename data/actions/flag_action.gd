extends Action
class_name FlagAction

@export var add_flag: Array[Flag]
@export var remove_flag: Array[Flag]
@export var required_flag: Array[Flag]
@export var forbidden_flag: Array[Flag]

func use() -> void:
	for flag in add_flag:
		FlagsManager.add_flag(flag)
	for flag in remove_flag:
		FlagsManager.remove_flag(flag)

func requirement_met() -> bool:
	for flag in forbidden_flag:
		if FlagsManager.has_flag(flag):
			return false

	for flag in required_flag:
		if not FlagsManager.has_flag(flag):
			return false
	return true
