extends TabBar

@onready var main_dropdown: OptionButton = %MainDropdown
@onready var id_line: LineEdit = %IDLine
@onready var title_line: LineEdit = %TitleLine
@onready var description_edit: TextEdit = %DescriptionEdit
@onready var image_rect: TextureRect = %ImageRect
@onready var img_file_dialog: FileDialog = %ImgFileDialog

const FOLDER :String = "res://data/events/"
var list: Array[Event] = []
var current_event: Event

func _ready() -> void:
	_update()

func _on_main_dropdown_item_selected(index: int) -> void:
	if index == 0:
		_new()
	else:
		_load(list[index - 1])

func _on_save_btn_pressed() -> void:
	_save()

func _on_new_btn_pressed() -> void:
	_new()

func _on_add_img_btn_pressed() -> void:
	img_file_dialog.popup_centered_ratio(0.8)

func _on_img_file_dialog_file_selected(path: String) -> void:
	var texture = load(path) as Texture2D
	if texture == null: return
	image_rect.texture = texture

# ================================================== helper
func _update():
	list.clear()
	_load_folder(FOLDER)
	_update_dropdown()

func _load_folder(folder_path: String) -> void:
	var dir := DirAccess.open(folder_path)
	if dir == null: return

	dir.list_dir_begin()
	var file_name := dir.get_next()

	while not file_name.is_empty():
		var path := folder_path.path_join(file_name)

		if dir.current_is_dir():
			_load_folder(path)

		elif file_name.get_extension().to_lower() == "tres":
			var event := load(path) as Event

			if event != null:
				list.push_back(event)

		file_name = dir.get_next()

	dir.list_dir_end()

func _update_dropdown() -> void:
	main_dropdown.clear()
	main_dropdown.add_item('unknown/new')
	for item in list:
		main_dropdown.add_item(item.id)

func _new():
	_load(Event.new())

func _load(event: Event) -> void:
	current_event = event
	id_line.text = current_event.id
	title_line.text = current_event.titel
	description_edit.text = current_event.description
	image_rect.texture = current_event.img

func _save() -> void:
	if current_event == null:
		return
	current_event.id = Utils.string_to_id(id_line.text)
	current_event.titel = title_line.text.strip_edges()
	current_event.description = description_edit.text
	current_event.img = image_rect.texture

	if current_event.id.is_empty():
		push_warning("Invalid event ID.")
		return

	var old_path := current_event.resource_path
	var folder := FOLDER.path_join(current_event.id)
	var new_path := folder.path_join(current_event.id + ".tres")

	if new_path != old_path and FileAccess.file_exists(new_path):
		push_warning("An event with this ID already exists.")
		return

	DirAccess.make_dir_recursive_absolute(folder)
	var error := ResourceSaver.save(current_event, new_path)
	if error != OK:
		push_error("Could not save event: " + error_string(error))
		return

	if not old_path.is_empty() and old_path != new_path:
		error = DirAccess.remove_absolute(old_path)
		if error != OK:
			push_warning("The new event was saved, but the old file could not be removed.")

	_update()
