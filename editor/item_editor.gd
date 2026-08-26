extends TabBar

@onready var item_dropdown: OptionButton = %ItemDropdown
@onready var title_line: LineEdit = %TitleLine
@onready var price_spin: SpinBox = %PriceSpin
@onready var weight_spin: SpinBox = %WeightSpin
@onready var icon_preview: TextureRect = %IconPreview
@onready var icon_file_dialog: FileDialog = %IconFileDialog

const FOLDER := "res://data/item/"
var list: Array[Item] = []
var current_item: Item

func _ready() -> void:
	_update()
	_new()

func _on_item_dropdown_item_selected(index: int) -> void:
	if index == 0:
		_new()
	else:
		_load(list[index - 1])

func _on_save_btn_pressed() -> void:
	_save()

func _on_new_btn_pressed() -> void:
	item_dropdown.select(0)
	_new()

func _on_add_icon_btn_pressed() -> void:
	icon_file_dialog.popup_centered_ratio(0.8)

func _on_icon_file_dialog_file_selected(path: String) -> void:
	var texture := load(path) as Texture2D
	if texture == null: return
	icon_preview.texture = texture

# ================================================== helper
func _update():
	_load_list()
	_update_dropdown()
	item_dropdown.select(0)

func _load_list() -> void:
	list.clear()

	var dir := DirAccess.open(FOLDER)
	if dir == null: return
	dir.list_dir_begin()

	var file_name := dir.get_next()
	while not file_name.is_empty():
		if not dir.current_is_dir() and file_name.get_extension() == "tres":
			var path := FOLDER + file_name
			var item := load(path) as Item
			if item == null: continue
			list.push_back(item)
		file_name = dir.get_next()

	dir.list_dir_end()

func _update_dropdown() -> void:
	item_dropdown.clear()
	item_dropdown.add_item('unknown/new')
	for item in list:
		item_dropdown.add_item(item.title)

func _new():
	_load(Item.new())

func _load(item: Item) -> void:
	current_item = item
	title_line.text = current_item.title
	price_spin.value = current_item.price
	weight_spin.value = current_item.weight
	icon_preview.texture = current_item.icon

func _save():
	_save()
	if current_item == null:
		return

	current_item.title = title_line.text
	current_item.price = int(price_spin.value)
	current_item.weight = int(weight_spin.value)
	current_item.icon = icon_preview.texture

	if title_line.text.is_empty():
		return
	var path := current_item.resource_path
	if path.is_empty():
		path = FOLDER + current_item.id + ".tres"
	ResourceSaver.save(current_item, path)
