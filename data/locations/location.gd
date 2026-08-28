extends Resource
class_name Location

@export var title = ""
var id: StringName:
	get:
		return Utils.string_to_id(title)
@export var image : Texture2D
@export_multiline var description = ""

@export_group("Shop")
@export var cheap_items : Array[Item]
@export var expensive_items : Array[Item]

@export_group("Events")
@export var random_event_chance := 25
@export var random_events : Array[Event]
@export var quest_events : Array[Event]

func has_item(item : Item) -> bool:
	if item == null:
		return false
	for local_item: Item in cheap_items:
		if local_item != null and local_item.id == item.id:
			return true
	for local_item: Item in expensive_items:
		if local_item != null and local_item.id == item.id:
			return true
	return false

func has_shop() -> bool:
	return not cheap_items.is_empty() or not expensive_items.is_empty()

func has_valid_random_events() -> bool:
	for event in random_events:
		if event == null:
			continue
		if EventManager.recent_random_events.has(event.id):
			continue
		if event.requirements_are_met():
			return true
	return false

func get_random_event(chance: int = -1) -> Event:
	if chance < 0:
		chance = random_event_chance
	if Utils.rng.randi_range(1, 100) > chance:
		return null
	var available_events: Array[Event] = []
	for event in random_events:
		if event == null:
			continue
		if EventManager.recent_random_events.has(event.id):
			continue
		if not event.requirements_are_met():
			continue
		available_events.append(event)
	if available_events.is_empty():
		return null
	return available_events.pick_random()
