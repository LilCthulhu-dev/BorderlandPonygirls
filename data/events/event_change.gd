extends _EventContent
class_name EventChange

@export var btn_text := ""
@export var target_event : Event
@export var target_combat : Combat
@export var actions : Array[Action]

func hard_requierments_met() -> bool:
	return target_event != null or target_combat != null
