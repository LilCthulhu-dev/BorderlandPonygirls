extends DefaultBtn

var content : EventChange

func _ready() -> void:
	super()
	text = "> " + content.btn_text
	disabled = !content.soft_requirements_met()
	_add_tooltip()

func _add_tooltip() -> void:
	var tip_array := TooltipManager.get_tooltips(content.actions)
	tooltip = "\n".join(tip_array)
	if not tooltip.is_empty():
		add_questionmark()

func _get_result_text() -> String:
	var arr: Array[String] = []
	var txt = ""
	for action in content.actions:
		var result := action.get_result()
		if not result.is_empty():
			arr.push_back(result)
	if arr.size() > 0:
		txt += "\n\n"
		txt += "\n".join(arr)
	return txt

func _on_pressed() -> void:
	for action in content.actions:
		action.use()
	if content.target_event:
		LocationManager.current_event = content.target_event
		GlobalSignals.update_event.emit()
	elif content.target_combat:
		CombatManager.current_combat = content.target_combat
		CombatManager.start_combat()
		SceneManager.change_scene(SceneManager.COMBAT_WINDOW)
