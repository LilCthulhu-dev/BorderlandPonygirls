extends Action
class_name FocusQuestPonygirl


func use() -> void:
	if FlagsManager.quest_ponygirl != null:
		PonygirlManager.focused_ponygirl = FlagsManager.quest_ponygirl


func requirement_met() -> bool:
	return FlagsManager.quest_ponygirl != null
