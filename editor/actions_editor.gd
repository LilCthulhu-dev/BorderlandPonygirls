extends FoldableContainer
class_name ActionEditor

@onready var container: VBoxContainer = %Container
@onready var new_action: OptionButton = %NewAction
@onready var action_content: VBoxContainer = %ActionContent

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
func update_action_list() -> void:
	Utils.clear_container(container)
	for action in list_of_actions:
		var btn := DefaultBtn.new()
		btn.text = action.get_class_name()
		btn.pressed.connect(_on_open_action_pressed.bind(action))
		container.add_child(btn)

func _on_open_action_pressed(action : Action):
	print(action, "BERT")

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
