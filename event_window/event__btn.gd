extends DefaultBtn

var content : EventBtn

func _ready() -> void:
	super()
	if content == null:
		queue_free()
		return
	text = "> " + content.btn_text
	if !content.soft_requirements_met():
		disabled = true
	if content.single_use && content.used:
		disabled = true
	_prep_tooltip()

func _prep_tooltip() -> void:
	tooltip = TooltipManager.get_tooltips_from_actions(content.actions)
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

func _on_pressed() -> void:
	if content == null or content.actions.is_empty():
		EventManager.current_event = null
		SceneManager.change_scene(SceneManager.MAIN_WINDOW)
		return
	if content.single_use:
		content.used = true
	var result_text := _get_result_text()
	if not result_text.is_empty():
		ModalManager.open_event_result_modal(content.actions)
	else:
		for action in content.actions:
			action.use()
