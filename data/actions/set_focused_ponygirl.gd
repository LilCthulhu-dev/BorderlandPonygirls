extends Action
class_name SetFocusedPonygirl

var pony: Ponygirl

func use() -> void:
	if pony != null:
		PonygirlManager.focused_ponygirl = pony

func requirement_met() -> bool:
	return pony != null
