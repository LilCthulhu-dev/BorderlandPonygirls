extends Action
class_name ChangeEvent

@export_file("*.tres") var event_path: String

func use():
	EventManager.current_event = _get_target_event()
	if GameData.game_state != Enums.GAME_STATES.EVENT:
		SceneManager.change_scene(SceneManager.EVENT_WINDOW)

func requirement_met() -> bool:
	var target_event := _get_target_event()
	if target_event == null: return false
	return target_event.requirements_are_met()

func get_tooltip() -> String:
	if hide_tooltip: return ""
	var target_event := _get_target_event()
	if target_event == null: return ""
	var texts: Array[String] = []
	for action in target_event.open_actions:
		var text := action.get_tooltip()
		if not text.is_empty():	texts.append(text)
	return "\n".join(texts)

func get_result() -> String:
	return ""

func _get_target_event() -> Event:
	return load(event_path) as Event
