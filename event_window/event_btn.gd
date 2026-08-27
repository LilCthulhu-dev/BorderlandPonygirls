extends DefaultBtn

var content : EventBtn

func _ready() -> void:
	super()
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

func _on_pressed() -> void:
	content.use()
	if content.single_use:
		content.used = true
