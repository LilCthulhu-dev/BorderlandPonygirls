extends _EventContent
class_name EventBtn

@export var _btn_text: String
var btn_text: String:
	set(value):
		_btn_text = value
	get:
		return Utils.translate(_btn_text)

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
	if single_use && used:
		return false
	return true

func reset():
	used = false
