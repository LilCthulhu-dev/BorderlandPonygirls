extends Action
class_name ChangeSubmission

enum TARGET {
	FOCUSED,
	RANDOM,
	ACTIVE,
	ALL
}

@export var amount: int
@export var target := TARGET.RANDOM
var affected_ponygirls: Array[Ponygirl] = []

func use() -> void:
	affected_ponygirls = get_target_ponygirls()
	for ponygirl in affected_ponygirls:
		ponygirl.submission += amount

func requirement_met() -> bool:
	return not get_target_ponygirls().is_empty()

func get_target_ponygirls() -> Array[Ponygirl]:
	var target_ponygirls: Array[Ponygirl] = []
	match target:
		TARGET.FOCUSED:
			if PonygirlManager.focused_ponygirl:
				target_ponygirls.append(PonygirlManager.focused_ponygirl)
		TARGET.RANDOM:
			var ponygirl : Ponygirl = PonygirlManager.get_random_active_ponygirl()
			if ponygirl:
				target_ponygirls.append(ponygirl)
		TARGET.ACTIVE:
			target_ponygirls = PonygirlManager.get_active_ponygirls()
		TARGET.ALL:
			target_ponygirls = PonygirlManager.ponygirls
	return target_ponygirls

func _get_txt() -> String:
	var amt: String = str(abs(amount))
	var verb_s: String = Utils.translate("gains") if amount > 0 else Utils.translate("loses")
	var verb_p: String = Utils.translate("gain") if amount > 0 else Utils.translate("lose")
	match target:
		TARGET.FOCUSED:
			return Utils.translate("Selected Ponygirl %s %s Submission") % [verb_s, amt]
		TARGET.RANDOM:
			return Utils.translate("A random active ponygirl %s %s Submission") % [verb_s, amt]
		TARGET.ACTIVE:
			return Utils.translate("All active ponygirls %s %s Submission") % [verb_p, amt]
		TARGET.ALL:
			return Utils.translate("All ponygirls %s %s Submission") % [verb_p, amt]
	return ""

func get_tooltip() -> String:
	if hide_tooltip: return ""
	return _get_txt()

func get_result() -> String:
	if hide_description: return ""
	var amt: String = str(abs(amount))
	var verb_s: String = Utils.translate("gains") if amount > 0 else Utils.translate("loses")
	var text := _get_txt()
	if target == TARGET.FOCUSED:
		text = Utils.translate("{PONYNAME} %s %s Submission") % [verb_s, amt]
	if target == TARGET.RANDOM and not affected_ponygirls.is_empty():
		text = Utils.translate("%s %s %s Submission") % [affected_ponygirls[0].name, verb_s, amt]
	if text.is_empty(): return ""
	return "- " + text
