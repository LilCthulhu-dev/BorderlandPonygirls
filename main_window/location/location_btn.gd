extends DefaultBtn

@export var actions : Array[Action]

func _ready() -> void:
	super()
	GlobalSignals.update_location.connect(_check_requierments)
	GlobalSignals.tab_clicked.connect(_on_tab_clicked)
	_check_requierments()
	_prep_tooltip()

func _on_tab_clicked(_index, _titel):
	_check_requierments()

func _check_requierments() -> void:
	disabled = false
	for action in actions:
		if not action.requirement_met():
			disabled = true
			break

func _prep_tooltip():
	for action in actions:
		if action.get_tooltip() == "": continue
		if tooltip != "": tooltip += "\n"
		tooltip += action.get_tooltip()

func _get_result_text() -> Array[String]:
	var results : Array[String] = []
	for action in actions:
		if action.get_result() == "": continue
		results.push_back(action.get_result())
	return results

func _on_pressed() -> void:
	if actions.is_empty():
		return
	for action in actions:
		action.use()
	GlobalSignals.update_location.emit()
	if not _get_result_text().is_empty():
		ModalManager.open_loaction_result_modal(_get_result_text())
