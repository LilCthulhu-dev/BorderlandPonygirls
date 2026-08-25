extends TabBar

@onready var dropdown: OptionButton = %Dropdown
@onready var description_edit: TextEdit = %DescriptionEdit
@onready var malus_dropdown: OptionButton = %MalusDropdown
@onready var bonus_dropdown: OptionButton = %BonusDropdown
@onready var group_dropdown: OptionButton = %GroupDropdown
@onready var background_check: CheckBox = %BackgroundCheck

const FOLDER := "res://data/perks/"
var list: Array[Perk] = []
var current_perk: Perk
var current_path := ""

func _ready() -> void:
	_update_editor()

# ================================================== helper
func _update_editor():
	_load_item_list()
	_update_dropdown()
	dropdown.select(0)


func _load_item_list() -> void:
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

func _update_dropdown() -> void:
	dropdown.clear()
	dropdown.add_item('unknown/new')
	for item in list:
		dropdown.add_item(item.name)
