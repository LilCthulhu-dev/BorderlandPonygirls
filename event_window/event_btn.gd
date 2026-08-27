extends DefaultBtn

var content : EventBtn

func _ready() -> void:
	super()
	if content == null:
		text = "> Return to Main"
		disabled = false
	else:
		text = "> " + content.txt
		if !content.soft_requirements_met():
			disabled = true
		if content.single_use && content.used:
			disabled = true
		_prep_tooltip()

func _prep_tooltip() -> void:
	if content == null: return
	var tip_array := TooltipManager.get_tooltips(content.actions)
	tooltip = "\n".join(tip_array)
	if not tooltip.is_empty():
		add_questionmark()

func _get_result_text() -> Array[String]:
	var results: Array[String] = []
	if content == null: return results
	for action in content.actions:
		var result := action.get_result()
		if not result.is_empty():
			results.push_back(result)
	return results

func _get_description() -> Action:
	for action in content.actions:
		if action is AddDescription:
			return action
	return null

func _on_pressed() -> void:
	if content == null or content.actions.is_empty():
		LocationManager.current_event = null
		SceneManager.change_scene(SceneManager.MAIN_WINDOW)
		return
	if content.single_use:
		content.used = true

	var description = _get_description()
	if description:
		ModalManager.open_event_result_modal(
			content.actions,
			description.get_result())
	else:
		for action in content.actions:
			action.use()
