extends DefaultBtn

var content : EventInfo

func _ready() -> void:
	super()
	text = "> " + content.btn_text
	disabled = !content.soft_requirements_met()
	_add_tooltip()

func _add_tooltip() -> void:
	var tips_array := TooltipManager.get_tooltips(content.actions)
	tooltip = "\n".join(tips_array)
	if not tooltip.is_empty():
		add_questionmark()

func _on_pressed() -> void:
	for action in content.actions:
		action.use()
	if content.single_use:
		content.used = true
	if content.end_conversation:
		LocationManager.current_event.content.clear()
	LocationManager.current_event.description = content.description
	GlobalSignals.update_event.emit()
