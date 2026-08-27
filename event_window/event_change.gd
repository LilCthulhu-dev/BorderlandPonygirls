extends DefaultBtn

var content : EventChange

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
	if content.target_event:
		LocationManager.current_event = content.target_event
		GlobalSignals.update_event.emit()
	elif content.target_combat:
		CombatManager.current_combat = content.target_combat
		CombatManager.start_combat()
		SceneManager.change_scene(SceneManager.COMBAT_WINDOW)
