extends Action
class_name SpawnQuestPonygirl

## Create a one-shot held mare (random name/look) without adding her to the stable yet.


func use() -> void:
	FlagsManager.set_quest_ponygirl(_spawn())


func requirement_met() -> bool:
	return true


func get_tooltip() -> String:
	if hide_tooltip:
		return ""
	return Utils.translate("Find the missing mare.")


func get_result() -> String:
	if hide_description:
		return ""
	var n := FlagsManager.quest_ponygirl_name()
	if n.is_empty():
		return Utils.translate("- The missing mare is in your custody.")
	return Utils.translate("- {QUEST_PONY} is in your custody.")


func _spawn() -> Ponygirl:
	var base := load("res://data/ponygirls/default_pony.tres") as Ponygirl
	var p: Ponygirl = base.duplicate(true) as Ponygirl
	p.id = ""
	p.name = ""
	p._race = Enums.PONYGIRL_RACES.HUMAN
	p.hair_color = ""
	p.eye_color = ""
	p.skin_tone = ""
	p.portrait = null
	p.xp = 5
	p.submission = 0
	p.arousal = 35
	p.init()
	p.submission = 0
	p.arousal = 35
	var stubborn: Perk = PonygirlManager.get_perk_by_name("Stubborn")
	if stubborn != null and not p.perks.has(stubborn):
		p.perks.append(stubborn)
	if p.portrait == null and PonygirlManager.PORTRAITS.has(p._race):
		p.portrait = PonygirlManager.PORTRAITS[p._race].pick_random()
	return p
