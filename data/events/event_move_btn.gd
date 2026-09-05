@tool
extends _EventContent
class_name EventMoveBtn

@export var _btn_text: String
var btn_text: String:
	set(value):
		_btn_text = value
	get:
		return Utils.translate(_btn_text)
@export_file("*.tres") var target_event_path: String:
	set(value):
		target_event_path = value
		notify_property_list_changed()
var target_event: Event:
	get:
		return load(target_event_path) as Event
@export var target_combat: Combat:
	set(value):
		target_combat = value
		notify_property_list_changed()
@export var actions : Array[Action]

func _validate_property(property: Dictionary) -> void:
	if property.name == "target_event_path" and target_combat != null:
		property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name == "target_combat" and not target_event_path.is_empty():
		property.usage &= ~PROPERTY_USAGE_EDITOR

func use():
	for action in actions:
		action.use()
	if target_event:
		_use_event()
	else:
		_use_combat()

func _use_event():
	EventManager.current_event = target_event
	if GameData.game_state != Enums.GAME_STATES.EVENT:
		SceneManager.change_scene(SceneManager.EVENT__WINDOW)
	else:
		GlobalSignals.update_event.emit()

func _use_combat():
	CombatManager.current_combat = target_combat
	CombatManager.start_combat()
	SceneManager.change_scene(SceneManager.COMBAT_WINDOW)

func soft_requirements_met() -> bool:
	for action in actions:
		if not action.requirement_met():
			return false
	return true

func hard_requierments_met() -> bool:
	if target_event == null && target_combat == null:
		return false
	for action in actions:
		if not action.requirement_met() && action.hard_requierment:
			return false
	return true
