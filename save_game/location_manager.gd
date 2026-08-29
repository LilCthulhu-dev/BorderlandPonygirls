extends Resource
class_name LocationManager

@export var _home_location : Location
@export var _location_markers: Dictionary = {}
@export var _player_pos := Vector2.ZERO
@export var _current_location: Location

# ================================================== set/get
static var home_location: Location:
	set(value):
		GameData.location_manager._home_location = value
	get:
		return GameData.location_manager._home_location
static var location_markers: Dictionary:
	set(value):
		GameData.location_manager._location_markers = value
	get:
		return GameData.location_manager._location_markers
static var player_pos: Vector2:
	set(value):
		GameData.location_manager._player_pos = value
	get:
		return GameData.location_manager._player_pos
static var current_location: Location:
	set(value):
		GameData.location_manager._current_location = value
		if not value.title == "Wilderness" && AttributesManager.gold > 0:
			SaveGame.save(0)
		GlobalSignals.update_location.emit()
	get:
		return GameData.location_manager._current_location

# ================================================== helper
static func get_player_pos() -> Vector2:
	if current_location.id == &"wilderness":
		return player_pos
	return get_current_location_marker().position

static func get_current_location_marker() -> LocationMarker:
	return location_markers[current_location.id] as LocationMarker

static func has_location_valid_random_events() -> bool:
	if current_location == null:
		return false
	return current_location.has_valid_random_events()

static func check_for_random_event(chance: int = -1) -> bool:
	if current_location == null:
		return false
	if chance < 100 and GameData.TESTING:
		return false
	var event := current_location.get_random_event(chance)
	if event == null:
		return false
	EventManager.recent_random_events.append(event.id)
	while EventManager.recent_random_events.size() > 2:
		EventManager.recent_random_events.pop_front()
	EventManager.current_event = event
	SceneManager.change_scene(SceneManager.EVENT__WINDOW)
	return true
