extends _EventContent
class_name EventBtn

@export var txt := "":
	get:
		return Utils.translate(txt)
@export var actions : Array[Action]

@export_group('uses')
@export var single_use = false
@export var used = false

func use():
	var result_text := _get_result_text()
	if not result_text.is_empty():
		ModalManager.open_event_result_modal(actions)
	elif not actions.is_empty():
		for action in actions:
			action.use()
	else:
		var back = BackToMain.new()
		back.use()

func _get_result_text() -> Array[String]:
	var results: Array[String] = []
	for action in actions:
		var result := action.get_result()
		if not result.is_empty():
			results.push_back(result)
	return results

func soft_requirements_met() -> bool:
	for action in actions:
		if not action.requirement_met():
			return false
	return true

func hard_requierments_met() -> bool:
	for action in actions:
		if not action.requirement_met() && action.hard_requierment:
			return false
	if single_use && used:
		return false
	return true

func reset():
	used = false
