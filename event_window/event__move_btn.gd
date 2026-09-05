extends DefaultBtn

var content : EventMoveBtn

func _ready() -> void:
	super()
	if content == null:
		queue_free()
		return
	text = "> " + content.btn_text
	disabled = !content.soft_requirements_met()
	_prep_tooltip()

func _prep_tooltip() -> void:
	tooltip = TooltipManager.get_tooltips_from_actions(content.actions)
	if not tooltip.is_empty():
		add_questionmark()

func _on_pressed() -> void:
	content.use()
