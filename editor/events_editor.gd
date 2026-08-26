extends TabBar

@onready var main_dropdown: OptionButton = %MainDropdown
@onready var title_line: LineEdit = %TitleLine

const FOLDER :String = "res://data/events/"
var list: Array[Event] = []

func _ready() -> void:
	_update()
	print(list)

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
