extends Action
class_name ChangeArousal

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
		ponygirl.arousal += amount

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
			target_ponygirls = PonygirlManager.get_all_ponygirls()
	return target_ponygirls

func _get_txt() -> String:
	var amount_as_string: String = str(abs(amount)) if amount > -100 else Utils.translate("all")
	var verb_s: String = Utils.translate("gains") if amount > 0 else Utils.translate("loses")
	var verb_p: String = Utils.translate("gain") if amount > 0 else Utils.translate("lose")
	match target:
		TARGET.FOCUSED:
			return Utils.translate("Selected ponygirl %s %s Arousal") % [verb_s, amount_as_string]
		TARGET.RANDOM:
			return Utils.translate("A random active ponygirl %s %s Arousal") % [verb_s, amount_as_string]
		TARGET.ACTIVE:
			return Utils.translate("All active ponygirls %s %s Arousal") % [verb_p, amount_as_string]
		TARGET.ALL:
			return Utils.translate("All ponygirls %s %s Arousal") % [verb_p, amount_as_string]
	return ""

func get_tooltip() -> String:
	if hide_tooltip: return ""
	return _get_txt()

func get_result() -> String:
	if hide_description:
		return ""
	var amount_as_string: String = str(abs(amount)) if amount > -100 else Utils.translate("all")
	var verb_s: String = Utils.translate("gains") if amount > 0 else Utils.translate("loses")
	var text := _get_txt()
	if target == TARGET.FOCUSED:
		text = Utils.translate("{PONYNAME} %s %s Arousal") % [verb_s, amount_as_string]
	elif target == TARGET.RANDOM and not affected_ponygirls.is_empty():
		text = Utils.translate("%s %s %s Arousal") % [affected_ponygirls[0].name, verb_s, amount_as_string]
	if text.is_empty():
		return ""
	return "- " + text

func _get_singular_verb() -> String:
	return "gains" if amount > 0 else "loses"

func _get_plural_verb() -> String:
	return "gain" if amount > 0 else "lose"
