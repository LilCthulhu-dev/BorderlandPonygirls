extends VBoxContainer

@onready var item_dropdown: OptionButton = %ItemDropdown
@onready var title_line: LineEdit = %TitleLine
@onready var price_spin: SpinBox = %PriceSpin
@onready var weight_spin: SpinBox = %WeightSpin
@onready var icon_preview: TextureRect = %IconPreview

const ITEM_FOLDER := "res://data/item/"
var list_of_items: Array[Item] = []
var current_item: Item
var current_item_path := ""

func _ready() -> void:
	_update_editor()
	_new_item()

func _on_save_btn_pressed() -> void:
	_save_item()
	_update_editor()

func _on_new_btn_pressed() -> void:
	item_dropdown.select(0)
	_new_item()

func _on_item_dropdown_item_selected(index: int) -> void:
	if index == 0:
		_new_item()
	else:
		load_item(list_of_items[index - 1])

func _update_editor():
	_load_item_list()
	_update_dropdown()
	item_dropdown.select(0)

func _update_dropdown() -> void:
	item_dropdown.clear()
	item_dropdown.add_item('unknown/new')
	for item in list_of_items:
		item_dropdown.add_item(item.title)

func _load_item_list() -> void:
	list_of_items.clear()

	var dir := DirAccess.open(ITEM_FOLDER)
	if dir == null: return
	dir.list_dir_begin()

	var file_name := dir.get_next()
	while not file_name.is_empty():
		if not dir.current_is_dir() and file_name.get_extension() == "tres":
			var path := ITEM_FOLDER + file_name
			var item := load(path) as Item
			if item == null: continue
			list_of_items.push_back(item)
		file_name = dir.get_next()

	dir.list_dir_end()

func load_item(item: Item) -> void:
	current_item = item
	title_line.text = current_item.title
	price_spin.value = current_item.price
	weight_spin.value = current_item.weight
	icon_preview.texture = current_item.icon

func _new_item():
	current_item = Item.new()
	current_item_path = ""
	load_item(current_item)

func _save_item():
	current_item.title = title_line.text
	current_item.price = int(price_spin.value)
	current_item.weight = int(weight_spin.value)
	current_item.icon = icon_preview.texture
	var path := current_item.resource_path
	if path.is_empty():
		path = ITEM_FOLDER + current_item.id + ".tres"
	ResourceSaver.save(current_item, path)