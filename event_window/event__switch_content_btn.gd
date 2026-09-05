extends DefaultBtn

var content : EventSwitchContentBtn

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

func _on_pressed() -> void:
	EventManager.current_event.description = content.new_content_text
	if content.end_conversation:
		EventManager.current_event.content.clear()
	if content.single_use:
		content.used = true
	for action in content.actions:
		action.use()
	GlobalSignals.update_event.emit()
