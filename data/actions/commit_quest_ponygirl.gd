extends Action
class_name CommitQuestPonygirl

## Move the held quest mare into the stable (same instance, no second init).


func use() -> void:
	var p: Ponygirl = FlagsManager.quest_ponygirl
	if p == null:
		return
	PonygirlManager.add_ponygirl_instance(p)


func requirement_met() -> bool:
	if FlagsManager.quest_ponygirl == null:
		return false
	return PonygirlManager.slots_free()


func get_tooltip() -> String:
	if hide_tooltip:
		return ""
	return Utils.translate("Add the missing mare to your stable.")


func get_result() -> String:
	if hide_description:
		return ""
	var n := FlagsManager.quest_ponygirl_name()
	if n.is_empty():
		return Utils.translate("- Add the missing mare to your stable.")
	return Utils.translate("- Add ponygirl %s to your stable") % n
