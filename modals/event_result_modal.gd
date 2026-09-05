extends Modal

@onready var titel_label: Label = %TitelLabel
@onready var description_label: Label = %DescriptionLabel
@onready var results_label: Label = %ResultsLabel
var description : = ""
var actions : Array[Action]

func _ready() -> void:
	super()
	description_label.text = description
	for action in actions:
		var result_txt = action.get_result()
		if result_txt == "": continue
		if action is AddDescription:
			if description_label.text != "":
				description_label.text += "\n"
			description_label.text += result_txt
			continue
		if results_label.text != "":
			results_label.text += "\n"
		results_label.text += result_txt

	description_label.visible = description_label.text != ""
	results_label.visible = results_label.text != ""

func close() -> void:
	if is_closing:
		return
	for action in actions:
		action.use()
	if EventManager.current_event != null:
		GlobalSignals.update_event.emit()
	super()

func _on_button_pressed() -> void:
	close()
