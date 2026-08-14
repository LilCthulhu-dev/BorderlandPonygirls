extends _EventContent
class_name EventCheck

@export var ability : Enums.ABILITIES
@export var modifier := 0
@export var succes_actions: Array[Action]
@export var fail_actions: Array[Action]
var used = false

## English sources; localize at display via Utils.translate.
@export var txt := ""
@export_multiline var succes_txt := ""
@export_multiline var fail_txt := ""

func reset():
	used = false

func soft_requirements_met() -> bool:
	for action in succes_actions:
		if not action.requirement_met():
			return false
	if used:
		return false
	return true

func hard_requierments_met() -> bool:
	for action in succes_actions:
		if not action.requirement_met() && action.hard_requierment:
			return false
	return true
