extends _EventContent
class_name EventRandomText

@export var txt_elements: Array[MultilineText] = []
@export var actions: Array[Action] = []

var txt := "":
	get:
		if txt_elements.is_empty():
			return ""
		var txt_element : MultilineText = txt_elements.pick_random()
		return Utils.translate(txt_element.text)

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
