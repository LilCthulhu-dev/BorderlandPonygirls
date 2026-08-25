extends _EventContent
class_name EventPonySelect

@export var button_txt := "Race with %s"
@export var actions: Array[Action] = []

func hard_requierments_met() -> bool:
	if PonygirlManager.get_active_ponygirls().is_empty():
		return false
	for action in actions:
		if not action.requirement_met() and action.hard_requierment:
			return false
	return true

