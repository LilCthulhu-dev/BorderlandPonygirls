extends ActionField

@onready var titel: Label = %Titel
@onready var line_edit: LineEdit = %LineEdit

func _ready() -> void:
	super()
	titel.text = _get_property_title() + ": "
	line_edit.text = str(action.get(_get_property_name()))

func _on_line_edit_text_changed(new_text: String) -> void:
	_set_value(new_text)
