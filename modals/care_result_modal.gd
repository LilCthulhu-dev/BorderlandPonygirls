extends Modal

@onready var label_description: Label = %LabelDescription
var actions : Array[Action]

func _ready() -> void:
	super()
	if actions is not Array[Action]: queue_free()
	if actions.is_empty(): queue_free()
	label_description.text = ""
	for action in actions:
		if label_description.text != "":
			label_description.text += "\n"
		label_description.text += action.get_result()
		if action is AddDescription:
			label_description.text += "\n"

func close():
	if is_closing:
		return
	super()
	GlobalSignals.update_ponygirls.emit()

func _on_accept_btn_pressed() -> void:
	for action in actions:
		action.use()
	close()

func _on_decline_btn_pressed() -> void:
	close()
