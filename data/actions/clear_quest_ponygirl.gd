extends Action
class_name ClearQuestPonygirl


func use() -> void:
	FlagsManager.clear_quest_ponygirl()


func get_result() -> String:
	if hide_description:
		return ""
	return ""
