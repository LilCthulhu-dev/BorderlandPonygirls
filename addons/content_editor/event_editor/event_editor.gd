@tool
extends TabBar

@onready var save_dialog: EditorFileDialog = %SaveDialog
@onready var event_picker: EditorResourcePicker = %EventPicker
@onready var save_btn: Button = %SaveBtn
@onready var new_btn: Button = %NewBtn
@onready var title_label: LineEdit = %TitleLabel
@onready var id_label: LineEdit = %IdLabel
@onready var image_picker: EditorResourcePicker = %ImagePicker
@onready var description_edit: TextEdit = %DescriptionEdit

var current_event: Event

func _ready() -> void:
	save_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	save_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	save_dialog.add_filter("*.tres", "Event Resource")
	_load_event(Event.new())

func _on_save_dialog_file_selected(path: String) -> void:
	if not path.ends_with(".tres"):
		path += ".tres"
	_save(path)
	event_picker.edited_resource = current_event
	save_btn.disabled = false

func _on_event_picker_resource_changed(resource: Resource) -> void:
	if resource is not Event: return
	_load_event(resource)

func _on_save_as_btn_pressed() -> void:
	if current_event == null:
		push_warning("Kein Event vorhanden.")
		return
	save_dialog.current_dir = "res://events"
	if not current_event.resource_path.is_empty():
		save_dialog.current_file = current_event.resource_path.get_file()
	elif not title_label.text.is_empty():
		save_dialog.current_file = string_to_id(title_label.text) + ".tres"
	else:
		save_dialog.current_file = "new_event.tres"
	save_dialog.popup_centered_ratio(0.7)

func _on_save_btn_pressed() -> void:
	_save(current_event.resource_path)

func _on_new_btn_pressed() -> void:
	_load_event(Event.new())

# =============================================== Helper
func string_to_id(text: String) -> String:
	var id := text.to_lower().strip_edges()
	id = id.replace(" ", "_")
	var regex := RegEx.new()
	regex.compile("[^a-z0-9_]")
	id = regex.sub(id, "", true)
	return id

func _load_event(new_event : Event) -> void:
	current_event = new_event

	event_picker.edited_resource = current_event
	title_label.text = current_event.titel if current_event.titel else ""
	id_label.text = current_event._id if current_event._id else ""
	image_picker.edited_resource = current_event.img if current_event.img else null
	description_edit.text = current_event._description if current_event._description else ""

	save_btn.disabled = current_event.resource_path.is_empty()
	title_label.grab_focus()

func _save(path: String) -> void:
	current_event.titel = title_label.text
	current_event._id = id_label.text
	current_event.img = image_picker.edited_resource as Texture2D
	current_event._description = description_edit.text

	var error := ResourceSaver.save(current_event, path)
	if error != OK:
		push_error("Event konnte nicht gespeichert werden: %s" % error)
		return
	save_btn.disabled = false
