extends TabBar

@onready var dropdown: OptionButton = %Dropdown
@onready var name_line: LineEdit = %NameLine
@onready var description_edit: TextEdit = %DescriptionEdit
@onready var malus_dropdown: OptionButton = %MalusDropdown
@onready var bonus_dropdown: OptionButton = %BonusDropdown
@onready var group_dropdown: OptionButton = %GroupDropdown
@onready var background_check: CheckBox = %BackgroundCheck

const FOLDER := "res://data/perks/"
var list: Array[Perk] = []
var current_perk: Perk

func _ready() -> void:
	_update()
	_new()

func _on_dropdown_item_selected(index: int) -> void:
	if index == 0:
		_new()
	else:
		_load(list[index - 1])

func _on_save_btn_pressed() -> void:
	_save()
	_update()

func _on_new_btn_pressed() -> void:
	dropdown.select(0)
	_new()

# ================================================== helper
func _update():
	_load_list()
	_update_dropdowns()
	dropdown.select(0)

func _load_list() -> void:
	list.clear()

	var dir := DirAccess.open(FOLDER)
	if dir == null: return
	dir.list_dir_begin()

	var file_name := dir.get_next()
	while not file_name.is_empty():
		if not dir.current_is_dir() and file_name.get_extension() == "tres":
			var path := FOLDER + file_name
			var perk := load(path) as Perk
			if perk == null: continue
			list.push_back(perk)
		file_name = dir.get_next()

	dir.list_dir_end()

func _update_dropdowns() -> void:
	dropdown.clear()
	malus_dropdown.clear()
	bonus_dropdown.clear()
	group_dropdown.clear()
	dropdown.add_item('unknown/new')
	for item in list:
		dropdown.add_item(item.name)
	for key in Enums.ATTRIBUTES.keys():
		var key_name := str(key).capitalize()
		malus_dropdown.add_item(key_name)
		bonus_dropdown.add_item(key_name)
	for key in Perk.GROUPS.keys():
		group_dropdown.add_item(str(key).capitalize())

func _load(perk: Perk) -> void:
	current_perk = perk
	name_line.text = current_perk.name
	description_edit.text = current_perk.description
	malus_dropdown.select(current_perk.malus)
	bonus_dropdown.select(current_perk.bonus)
	group_dropdown.select(current_perk.group)
	background_check.button_pressed = current_perk.background

func _new() -> void:
	_load(Perk.new())

func _save() -> void:
	if current_perk == null:
		return
	var path := current_perk.resource_path
	if path.is_empty():
		var id := Utils.string_to_id(name_line.text)
		if id.is_empty():
			return
		path = FOLDER + id + ".tres"
	current_perk.description = description_edit.text
	current_perk.malus = malus_dropdown.selected
	current_perk.bonus = bonus_dropdown.selected
	current_perk.group = group_dropdown.selected
	current_perk.background = background_check.button_pressed
	ResourceSaver.save(current_perk, path)
