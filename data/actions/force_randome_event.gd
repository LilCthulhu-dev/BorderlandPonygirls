extends Action
class_name ForceRandomeEvent

func use() -> void:
	super()
	LocationManager.check_for_random_event(100)

func requirement_met() -> bool:
	if LocationManager.current_location == null:
		return false
	return LocationManager.has_location_valid_random_events()

func get_tooltip() -> String:
	return "You might find something interesting, stumble upon an opportunity, or run into trouble."
