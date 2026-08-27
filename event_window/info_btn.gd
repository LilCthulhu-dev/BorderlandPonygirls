extends DefaultBtn

var content : InfoBtn

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
	if content.single_use:
		content.used = true
	if content.end_conversation:
		LocationManager.current_event.content.clear()
	LocationManager.current_event.description = content.description
	LocationManager.current_event.description += _get_result_text()
	GlobalSignals.update_event.emit()
