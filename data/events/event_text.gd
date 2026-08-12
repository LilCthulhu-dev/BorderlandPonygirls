extends _EventContent
class_name EventText

@export_multiline var txt := "":
	get:
		return Utils.translate(txt)
@export var actions : Array[Action]

func soft_requirements_met() -> bool:
	for action in actions:
		if not action.requirement_met():
			return false
	return true

func hard_requierments_met() -> bool:
	for action in actions:
		if not action.requirement_met() && action.hard_requierment:
			return false
	return true
