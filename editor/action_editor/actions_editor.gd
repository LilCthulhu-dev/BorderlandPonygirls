extends FoldableContainer
class_name ActionEditor

@onready var container: VBoxContainer = %Container
@onready var new_action: OptionButton = %NewAction
@onready var action_content: GridContainer = %ActionContent

const FOLDER = "res://data/actions/"
const NUMBER_FIELD = preload("uid://c05ewqi1axd1q")
const RESOURCE_FIELD = preload("uid://dgwu1ybiom4pm")
const TEXT_FIELD = preload("uid://bnn32f1m2vnmi")
const BOOLEAN_FIELD = preload("uid://dj71wynu1bdj1")
const UNSUPPORTED_FIELD = preload("uid://gavwvji6fx0f")
const ENUM_FIELD = preload("uid://j0u1bkdv01n3")

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

func _add_action_field(action: Action, property: Dictionary) -> void:
	var property_type := int(property.type)
	var property_hint := int(property.hint)

	match property_type:
		TYPE_OBJECT:
			if property_hint == PROPERTY_HINT_RESOURCE_TYPE:
				_add_resource(action, property)
			else:
				_add_unsupported(action, property)
		TYPE_INT:
			if property_hint == PROPERTY_HINT_ENUM:
				_add_enum(action, property)
			else:
				_add_number(action, property)
		TYPE_FLOAT:
			_add_number(action, property)
		TYPE_STRING:
			_add_string(action, property)
		TYPE_BOOL:
			_add_boolean(action, property)
		_:
			_add_unsupported(action, property)

func _add_option(option : ActionField, action : Action, property : Dictionary):
	option.setup(action, property)
	action_content.add_child(option)

func _add_resource(action : Action, property : Dictionary) -> void:
	var option = RESOURCE_FIELD.instantiate()
	_add_option(option, action, property)

func _add_number(action: Action, property) -> void:
	var option = NUMBER_FIELD.instantiate()
	_add_option(option, action, property)

func _add_string(action: Action, property) -> void:
	var option = TEXT_FIELD.instantiate()
	_add_option(option, action, property)

func _add_boolean(action: Action, property) -> void:
	var option = BOOLEAN_FIELD.instantiate()
	_add_option(option, action, property)

func _add_unsupported(action: Action, property) -> void:
	var option = UNSUPPORTED_FIELD.instantiate()
	_add_option(option, action, property)

func _add_enum(action: Action, property) -> void:
	var option = ENUM_FIELD.instantiate()
	_add_option(option, action, property)
