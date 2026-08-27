extends Modal

@onready var titel_label: Label = %TitelLabel
@onready var description_label: Label = %DescriptionLabel
var extra_text : = ""
var actions : Array[Action]

func _ready() -> void:
	super()
	description_label.text = extra_text
	description_label.visible = description_label.text != ""

func close() -> void:
	if is_closing:
		return
	for action in actions:
		action.use()
	if LocationManager.current_event != null:
		GlobalSignals.update_event.emit()
	super()

func _on_button_pressed() -> void:
	close()
