@tool
extends TabBar

@onready var save_dialog: EditorFileDialog = %SaveDialog
@onready var event_picker: EditorResourcePicker = %EventPicker
@onready var save_btn: Button = %SaveBtn
@onready var save_as_btn: Button = %SaveAsBtn
@onready var new_btn: Button = %NewBtn
@onready var title_label: LineEdit = %TitleLabel
@onready var id_label: LineEdit = %IdLabel
@onready var image_picker: EditorResourcePicker = %ImagePicker

var current_event: Event

func _ready() -> void:
	save_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	save_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	save_dialog.add_filter("*.tres", "Event Resource")

func _on_save_dialog_file_selected(path: String) -> void:
	if not path.ends_with(".tres"):
		path += ".tres"
	_save(path)
	event_picker.edited_resource = current_event
	save_btn.disabled = false

func _on_event_picker_resource_selected(resource: Resource, inspect: bool) -> void:
	if resource == null: return
	if resource is not Event: return
	current_event = resource
	_load_event()

func _on_save_as_btn_pressed() -> void:
	if current_event == null:
		push_warning("Kein Event vorhanden.")
		return
	save_dialog.current_dir = "res://events"
	if not current_event.resource_path.is_empty():
		save_dialog.current_file = current_event.resource_path.get_file()
	elif not title_label.text.is_empty():
		save_dialog.current_file = (
			Utils.string_to_id(title_label.text) + ".tres"
		)
	else:
		save_dialog.current_file = "new_event.tres"
	save_dialog.popup_centered_ratio(0.7)

func _on_save_btn_pressed() -> void:
	var path := current_event.resource_path
	_save(path)

func _on_new_btn_pressed() -> void:
	current_event = Event.new()
	event_picker.edited_resource = current_event
	_load_event()
	title_label.grab_focus()

# =============================================== Helper
func _load_event() -> void:
	var path := current_event.resource_path
	save_btn.disabled = path == null

	if current_event == null:
		title_label.text = ""
		id_label.text = ""
		image_picker.edited_resource = null
	else:
		title_label.text = current_event.titel
		id_label.text = current_event.id
		image_picker.edited_resource = current_event.img

func _save(path) -> void:
	if current_event == null:
		push_warning("Kein Event ausgewählt.")
		return

	current_event.titel = title_label.text
	current_event.img = image_picker.edited_resource as Texture2D


	if path.is_empty():
		push_warning("Das neue Event besitzt noch keinen Speicherpfad.")
		return

	var error := ResourceSaver.save(current_event, path)

	if error != OK:
		push_error("Event konnte nicht gespeichert werden: %s" % error)
		return

	current_event.emit_changed()
	print("Event gespeichert: ", path)
