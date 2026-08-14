extends Action
class_name AddPonygirl

@export var ponygirl: Ponygirl = preload("res://data/ponygirls/default_pony.tres")

@export var force_race := Enums.PONYGIRL_RACES.UNKNOWN
@export_range(-1, 100, 1) var force_loyalty: int = -1
@export_range(-1, 100, 1) var force_arousal: int = -1
@export_range(-1, 200, 1) var force_xp: int = -1
@export var perks :Array[Perk] = []

@export var guarantee_perk_ids: PackedStringArray = []

var _pending_name: String = ""

func use() -> void:
	var instance: Ponygirl = _spawn_instance()
	PonygirlManager.add_ponygirl(instance)

func requirement_met() -> bool:
	return PonygirlManager.slots_free()

func get_tooltip() -> String:
	return Utils.translate("Add a ponygirl to your stable.")

func get_result() -> String:
	return Utils.translate("- Add ponygirl %s to your stable") % _pending_name

func _source_name_hint() -> String:
	if ponygirl != null and not ponygirl.name.is_empty():
		return ponygirl.name
	return Ponygirl.get_random_name()

func _spawn_instance() -> Ponygirl:
	var p : Ponygirl = ponygirl if ponygirl != null else load("res://data/ponygirls/default_pony.tres")
	p = p.duplicate(true)

	p.id = ""
	if _pending_name.is_empty():
		_pending_name = Ponygirl.get_random_name()
	p.name = _pending_name
	p._race = force_race
	p.xp = force_xp
	p.loyalty = force_loyalty
	p.arousal = force_arousal
	p.perks = perks
	return p
