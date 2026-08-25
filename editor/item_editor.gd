extends VBoxContainer

@onready var item_dropdown: OptionButton = %ItemDropdown
@onready var title_line: LineEdit = %TitleLine
@onready var price_spin: SpinBox = %PriceSpin
@onready var weight_spin: SpinBox = %WeightSpin
@onready var icon_preview: TextureRect = %IconPreview

const ITEM_FOLDER := "res://data/item/"
var list_of_items: Array[Item] = []
var item_paths: Array[String] = []
var current_item: Item
var current_item_path := ""

func _ready() -> void:
	_update_editor()
	if not item_paths.is_empty():
		load_item(item_paths[0])
		item_dropdown.select(0)
	else:
		_new_item()

func _on_save_btn_pressed() -> void:
	_save_item()
	_update_editor()

func _on_new_btn_pressed() -> void:
	_new_item()
	_update_editor()

func _on_item_dropdown_item_selected(index: int) -> void:
	load_item(item_paths[index])

func _update_editor():
	_load_item_list()
	_update_dropdown()
	if not item_paths.is_empty():
		load_item(item_paths[0])
		item_dropdown.select(0)
	else:
		_new_item()

func _update_dropdown() -> void:
	item_dropdown.clear()
	for item in list_of_items:
		item_dropdown.add_item(item.title)

func _load_item_list() -> void:
	list_of_items.clear()
	item_paths.clear()

	var dir := DirAccess.open(ITEM_FOLDER)
	if dir == null: return
	dir.list_dir_begin()

	var file_name := dir.get_next()
	while not file_name.is_empty():
		if not dir.current_is_dir() and file_name.get_extension() == "tres":
			var path := ITEM_FOLDER + file_name
			var item := load(path) as Item

			if item != null:
				list_of_items.push_back(item)
				item_paths.push_back(path)
		file_name = dir.get_next()

	dir.list_dir_end()

func load_item(path: String) -> void:
	current_item = load(path) as Item
	current_item_path = path
	title_line.text = current_item.title
	price_spin.value = current_item.price
	weight_spin.value = current_item.weight
	icon_preview.texture = current_item.icon

func _new_item():
	current_item = Item.new()
	current_item_path = ""
	title_line.text = ""
	price_spin.value = 0
	weight_spin.value = 1
	icon_preview.texture = null

func _save_item():
	if current_item == null:
		return
	current_item.title = title_line.text
	current_item.price = int(price_spin.value)
	current_item.weight = int(weight_spin.value)
	current_item.icon = icon_preview.texture
	if current_item_path.is_empty():
		current_item_path = ITEM_FOLDER + current_item.id + ".tres"
	ResourceSaver.save(current_item, current_item_path)