extends Action
class_name AddPonygirl

@export var ponygirl : Ponygirl = preload("res://data/ponygirls/default_pony.tres")

@export_group('Adjustments')
@export var force_name = ""
@export var force_race := Enums.PONYGIRL_RACES.UNKNOWN
@export var force_hair_color := ""
@export var force_eye_color := ""
@export var force_skin_tone := ""
@export var force_portrait : Texture2D

@export_range(0, 100, 1) var force_submission: int = 50
@export_range(0, 100, 1) var force_arousal: int = 0
@export_range(0, 80, 1) var force_xp: int = 0
@export var perks :Array[Perk] = []

var _pending_name: String = Ponygirl.get_random_name()

func use() -> void:
	PonygirlManager.add_ponygirl(_get_instance())

func requirement_met() -> bool:
	return PonygirlManager.slots_free()

func get_tooltip() -> String:
	return Utils.translate("Add a ponygirl to your stable.")

func get_result() -> String:
	return Utils.translate("- Add ponygirl %s to your stable") % _get_name()

func _get_name():
	return force_name if force_name != "" else _pending_name

func _get_instance() -> Ponygirl:
	var p : Ponygirl = ponygirl.duplicate(true)
	p.name = _get_name()
	p.id = ""
	p._race = force_race
	p.hair_color = force_hair_color
	p.eye_color = force_eye_color
	p.skin_tone = force_skin_tone
	if force_portrait != null:
		p.portrait = force_portrait
	p.xp = force_xp
	p.submission = force_submission
	p.arousal = force_arousal
	p.perks = perks.duplicate()
	return p
