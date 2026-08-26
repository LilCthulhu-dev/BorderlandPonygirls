extends FoldableContainer
class_name ActionEditor

@onready var container: VBoxContainer = %Container
@onready var new_action: OptionButton = %NewAction
@onready var action_content: HFlowContainer = %ActionContent

const FOLDER = "res://data/actions/"
var _list_of_actions : Array[Action] = []
var list_of_actions : Array[Action]:
	set(value):
		_list_of_actions = value
		update_action_list()
	get:
		return _list_of_actions
var _available_actions: Array[Action] = []

func _ready() -> void:
	update_action_list()
	_update_available_actions()
	_update_new_action_dropdown()

func _on_new_action_item_selected(index: int) -> void:
	_add_new_action(index)

# ============================================ Helper
func _update_full_width_rows() -> void:
	for child in action_content.get_children():
		if child.get_meta("full_width", false):
			child.custom_minimum_size.x = action_content.size.x

func update_action_list() -> void:
	Utils.clear_container(container)
	for action in list_of_actions:
		var btn := DefaultBtn.new()
		btn.text = action.get_class_name()
		btn.pressed.connect(_on_open_action_pressed.bind(action))
		container.add_child(btn)

func _update_available_actions() -> void:
	_available_actions.clear()

	var dir := DirAccess.open(FOLDER)
	if dir == null: return
	dir.list_dir_begin()
	var file_name := dir.get_next()

	while not file_name.is_empty():
		if not dir.current_is_dir() and file_name.get_extension() == "gd":
			var path := FOLDER.path_join(file_name)
			var script := load(path) as Script
			if script != null and script.can_instantiate():
				var action := script.new() as Action
				if action != null and action.get_class_name() != "Action":
					_available_actions.append(action)
		file_name = dir.get_next()

	dir.list_dir_end()

func _update_new_action_dropdown() -> void:
	new_action.clear()
	for action in _available_actions:
		new_action.add_item(action.get_class_name())
	new_action.select(-1)

func _add_new_action(index : int) -> void:
	var template: Action = _available_actions[index]
	var action_copy := template.duplicate(true) as Action
	_list_of_actions.append(action_copy)
	update_action_list()
	new_action.select(-1)

# ============================================ action field
func _on_open_action_pressed(action : Action):
	Utils.clear_container(action_content)
	for property in action.get_property_list():
		var usage := int(property.usage)
		if (usage & PROPERTY_USAGE_EDITOR) == 0: continue
		if (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) == 0: continue
		_add_action_field(action, property)
	_update_full_width_rows()

func _add_action_field(action: Action, property: Dictionary) -> void:
	var property_name := property.name as StringName
	var property_type := int(property.type)
	var property_hint := int(property.hint)

	# print("Type: ", type_string(property_type))

	if property_type == TYPE_INT and property_hint == PROPERTY_HINT_ENUM:
		_add_enum(action, property)
		return

	match property_type:
		TYPE_STRING:
			_add_string(action, property_name)
		TYPE_INT:
			_add_number(action, property_name, true)
		TYPE_FLOAT:
			_add_number(action, property_name, false)
		TYPE_BOOL:
			_add_boolean(action, property_name)
		_:
			_add_unsupported()

# row
func _get_row(property_name: String) -> HBoxContainer:
	var display_name := String(property_name).capitalize()
	var row := HBoxContainer.new()
	var label := Label.new()
	label.text = display_name
	label.custom_minimum_size.x = 150
	row.add_child(label)
	return row

# Enum
func _add_enum(action: Action, property: Dictionary) -> void:
	var row := _get_row(property.name)
	row.set_meta("full_width", true)
	action_content.add_child(row)

	var dropdown := OptionButton.new()
	dropdown.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(dropdown)

	var options := String(property.hint_string).split(",")
	for option in options:
		var parts := option.split(":")
		var option_name := parts[0].capitalize()
		var option_value := int(parts[1])
		dropdown.add_item(option_name, option_value)

	var property_name := property.name as StringName
	dropdown.select(action.get(property_name))
	dropdown.item_selected.connect(_on_enum_changed.bind(action, property_name))

func _on_enum_changed(index: int, dropdown: OptionButton, action: Action, property_name: StringName) -> void:
	action.set(property_name, index)
	action.emit_changed()

# string
func _add_string(action: Action, property_name: StringName) -> void:
	var row = _get_row(property_name)
	row.set_meta("full_width", true)
	action_content.add_child(row)

	var line_edit := LineEdit.new()
	line_edit.text = str(action.get(property_name))
	line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line_edit.text_changed.connect(_on_text_field_changed.bind(action, property_name))
	row.add_child(line_edit)

func _on_text_field_changed(value: String, action: Action,property_name: StringName) -> void:
	action.set(property_name, value)
	action.emit_changed()

# number
func _add_number(action: Action, property_name: StringName, is_integer = false) -> void:
	var row = _get_row(property_name)
	row.set_meta("full_width", true)
	action_content.add_child(row)

	var spinbox := SpinBox.new()
	spinbox.min_value = -999999
	spinbox.max_value = 999999
	spinbox.step = 1.0 if is_integer else 0.1
	spinbox.value = action.get(property_name)
	spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spinbox.value_changed.connect(_on_number_field_changed.bind(action, property_name, is_integer))
	row.add_child(spinbox)

func _on_number_field_changed(value: float, action: Action, property_name: StringName, is_integer: bool) -> void:
	if is_integer:
		action.set(property_name, int(value))
	else:
		action.set(property_name, value)
	action.emit_changed()

# boolean
func _add_boolean(action: Action, property_name: StringName) -> void:
	var checkbox := CheckBox.new()
	checkbox.text = String(property_name).capitalize()
	checkbox.button_pressed = action.get(property_name)
	checkbox.toggled.connect(_on_boolean_changed.bind(action, property_name))
	action_content.add_child(checkbox)

func _on_boolean_changed(value: bool, action: Action, property_name: StringName) -> void:
	action.set(property_name, value)
	action.emit_changed()

# unsupported
func _add_unsupported() -> void:
	var row = _get_row("Unsupported")
	var label := Label.new()
	label.text = "Unsupported type"
	row.add_child(label)
	action_content.add_child(row)
