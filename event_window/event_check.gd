extends DefaultBtn

var content : EventCheck
const DICE = preload("uid://rmhtqljr1v1r")
var ability_name : = ""

func _ready() -> void:
	super()
	ability_name = Enums.enum_to_name(Enums.ABILITIES, content.ability)
	text = "> %s (%s)" % [content.txt, ability_name]
	if !content.soft_requirements_met() or content.used:
		disabled = true
	_prep_tooltip()
	add_icon(DICE)

func _prep_tooltip():
	tooltip += "%s Check" % ability_name
	for action in content.succes_actions:
		if action.get_tooltip() == "": continue
		if tooltip != "": tooltip += "\n"
		tooltip += action.get_tooltip()

func _determin_success() -> bool:
	var role = Utils.roll_dice(100) + content.modifier
	var ability = AttributesManager.get_ability_value(content.ability)
	return ability >= role

func _get_result_text(success) -> Array[String]:
	var results : Array[String] = []
	results.push_front(content.succes_txt if success else content.fail_txt)
	results.push_back("")
	var actions = content.succes_actions if success else content.fail_actions
	for action in actions:
		if action.get_result() == "": continue
		results.push_back(action.get_result())
	return results

func _get_result_titel(success) -> String:
	if success:
		return "%s Check Succeeded" % ability_name
	else:
		return "%s Check Failed" % ability_name

func _on_pressed() -> void:
	var success = _determin_success()
	content.used = true
	ModalManager.open_event_result_modal(
		content.succes_actions if success else content.fail_actions,
		content.succes_txt if success else content.fail_txt)
