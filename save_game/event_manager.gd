extends Resource
class_name EventManager

@export var _current_event: Event = null
@export var _recent_random_events: Array[StringName] = []

static var recent_random_events: Array[StringName]:
	set(value):
		GameData.location_manager._recent_random_events = value
	get:
		return GameData.location_manager._recent_random_events

static var current_event: Event:
	set(value):
		if value == GameData.location_manager._current_event:
			return
		if GameData.location_manager._current_event != null:
			GameData.location_manager._current_event.close()
		GameData.location_manager._current_event = value
		if GameData.location_manager._current_event != null:
			GameData.location_manager._current_event.open()
			GlobalSignals.update_event.emit()
	get:
		return GameData.location_manager._current_event
