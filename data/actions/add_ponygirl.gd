extends Action
class_name AddPonygirl

## Optional base resource. Prefer archetype exports for repeatable events.
@export var ponygirl: Ponygirl = preload("res://data/ponygirls/default_pony.tres")

@export var randomize_name: bool = true
@export var randomize_appearance: bool = true

@export_range(-1, 100, 1) var force_loyalty: int = -1
@export_range(-1, 100, 1) var force_arousal: int = -1
@export_range(-1, 200, 1) var force_xp: int = -1
## -1 = random; else Enums.PONYGIRL_RACES (1 Human, 2 Elf, 3 Tiefling)
@export_range(-1, 3, 1) var force_race: int = -1

@export var guarantee_perk_ids: PackedStringArray = []

var _pending_name: String = ""


func use() -> void:
	var instance: Ponygirl = _spawn_instance()
	PonygirlManager.add_ponygirl_instance(instance)
	_pending_name = ""


func requirement_met() -> bool:
	return PonygirlManager.slots_free()


func get_tooltip() -> String:
	return Utils.translate("Add a ponygirl to your stable.")


func get_result() -> String:
	_pending_name = Ponygirl.get_random_name() if randomize_name else _source_name_hint()
	return Utils.translate("- Add ponygirl %s to your stable") % _pending_name


func _source_name_hint() -> String:
	if ponygirl != null and not ponygirl.name.is_empty():
		return ponygirl.name
	return Ponygirl.get_random_name()


func _spawn_instance() -> Ponygirl:
	var base: Ponygirl = ponygirl if ponygirl != null else load("res://data/ponygirls/default_pony.tres") as Ponygirl
	var p: Ponygirl = base.duplicate(true) as Ponygirl

	p.id = ""
	if randomize_name or p.name.is_empty():
		p.name = _pending_name if not _pending_name.is_empty() else Ponygirl.get_random_name()
	_pending_name = ""

	if force_race >= 1 and force_race <= 3:
		p._race = force_race as Enums.PONYGIRL_RACES
	elif randomize_appearance:
		p._race = Enums.PONYGIRL_RACES.UNKNOWN

	if randomize_appearance:
		p.hair_color = ""
		p.eye_color = ""
		p.skin_tone = ""
		p.portrait = null

	if force_xp >= 0:
		p.xp = force_xp

	p.init()

	if force_loyalty >= 0:
		p.loyalty = force_loyalty
	if force_arousal >= 0:
		p.arousal = force_arousal

	if randomize_appearance or p.portrait == null:
		if PonygirlManager.PORTRAITS.has(p._race):
			p.portrait = PonygirlManager.PORTRAITS[p._race].pick_random()

	_apply_guarantee_perks(p)
	return p


func _apply_guarantee_perks(p: Ponygirl) -> void:
	for perk_id in guarantee_perk_ids:
		var perk: Perk = _find_perk(str(perk_id))
		if perk == null:
			continue
		if not p.perks.has(perk):
			p.perks.append(perk)


func _find_perk(perk_id: String) -> Perk:
	var key: String = perk_id.strip_edges().to_lower().replace(" ", "_")
	for perk in GameData.list_of_perks:
		if perk == null:
			continue
		if str(perk.id) == key or perk.name.to_lower().replace(" ", "_") == key:
			return perk
	return PonygirlManager.get_perk_by_name(StringName(perk_id.capitalize()))
