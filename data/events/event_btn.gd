extends _EventContent
class_name EventBtn

@export var txt := "":
	get:
		return Utils.translate(txt)
@export var actions : Array[Action]
@export var single_use = false
@export var used = false

func soft_requirements_met() -> bool:
	for action in actions:
		if not action.requirement_met():
			return false
	return true

func hard_requierments_met() -> bool:
	for action in actions:
		if not action.requirement_met() && action.hard_requierment:
			return false
	if single_use && used:
		return false
	return true

func reset():
	used = false
