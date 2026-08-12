extends Resource
class_name Ponygirl

const XP_THRESHOLDS = [0, 10, 20, 40, 80]
const LOYALTY_THRESHOLDS = [30, 70]
const AROUSAL_THRESHOLDS = [25, 75];
const LEVEL_BONUS_THRESHOLDS = [4, 5];

@export var name := ""
@export var id := ""
@export var _race: Enums.PONYGIRL_RACES = Enums.PONYGIRL_RACES.UNKNOWN
@export var race := "":
	get:
		return Enums.PONYGIRL_RACES.keys()[_race].capitalize()
@export var hair_color := ""
@export var eye_color := ""
@export var skin_tone := ""
@export var portrait : Texture2D
@export var xp := 0:
	set(value):
		xp = value
		_update_normal_perks()
@export var perks :Array[Perk] = []
@export var loyalty := 50:
	set(value):
		loyalty = clamp(value, 0, 100)
		_update_background_perks()
@export var arousal := 0:
	set(value):
		arousal = clamp(value, 0, 100)
		_update_background_perks()
@export var active = false
var level :int:
	get:
		for i in range(XP_THRESHOLDS.size() - 1, -1, -1):
			if xp >= XP_THRESHOLDS[i]:
				return i + 1
		return 1

func init() -> void:
	if id.is_empty():
		id = str(ResourceUID.create_id())
	if name.is_empty():
		name = get_random_name()
	if _race == Enums.PONYGIRL_RACES.UNKNOWN:
		_race = _get_random_race()
	if hair_color.is_empty():
		hair_color = PonygirlManager.HAIR_COLORS.pick_random()
	if eye_color.is_empty():
		eye_color = PonygirlManager.EYE_COLORS.pick_random()
	if skin_tone.is_empty():
		skin_tone = PonygirlManager.SKIN_TONES.pick_random()
	if portrait == null and PonygirlManager.PORTRAITS.has(_race):
		portrait = PonygirlManager.PORTRAITS[_race].pick_random()
	_update_perks()

static func get_random_name() -> String:
	var first_name = PonygirlManager.FIRST_NAMES.pick_random()
	var last_name = PonygirlManager.LAST_NAMES.pick_random()
	return "%s-%s" % [first_name, last_name]

func _get_random_race() -> Enums.PONYGIRL_RACES:
	var roll := randi_range(0, 6)
	if roll < 4:
		return Enums.PONYGIRL_RACES.HUMAN
	elif roll < 6:
		return Enums.PONYGIRL_RACES.ELF
	else:
		return Enums.PONYGIRL_RACES.TIEFLING

# ======================================================= abilities
func get_mod_bonus() -> int:
	var bonus = 5
	var horny = PonygirlManager.get_perk_by_name('Horny')
	var desperately_horny = PonygirlManager.get_perk_by_name('Desperately Horny')
	if level == 4: bonus += 1
	if level == 5: bonus += 2
	if perks.has(horny): bonus += 2
	if perks.has(desperately_horny): bonus -= 2
	return bonus

func get_modifier(att : Enums.ATTRIBUTES) -> int:
	var modifier := 0
	var bonus = get_mod_bonus()
	for perk in perks:
		if perk.bonus == att: modifier += bonus
		if perk.malus == att: modifier -= 5
	return modifier

# ======================================================= perks
func _update_perks():
	_update_normal_perks()
	_update_background_perks()

func _update_normal_perks() -> void:
	var list_of_perks = GameData.list_of_perks.duplicate()
	list_of_perks.shuffle()
	while get_amount_of_normal_perks() < min(level, 3):
		var perk = list_of_perks.pop_front()
		if perk.background: continue
		if perks.has(perk): continue
		perks.push_back(perk)

func get_amount_of_normal_perks() -> int:
	var amount := 0
	for perk in perks:
		if perk.background:
			continue
		amount += 1
	return amount

func _update_background_perks() -> void:
	_toggle_perk("Unhappy", loyalty <= LOYALTY_THRESHOLDS[0])
	_toggle_perk("Happy", loyalty >= LOYALTY_THRESHOLDS[1])
	_toggle_perk("Horny", arousal >= AROUSAL_THRESHOLDS[0] && arousal < AROUSAL_THRESHOLDS[1])
	_toggle_perk("Desperately Horny", arousal >= AROUSAL_THRESHOLDS[1])

func _toggle_perk(perk_id: String, enable: bool):
	var perk = PonygirlManager.get_perk_by_name(perk_id)
	perks.erase(perk)
	if enable && perk: perks.append(perk)
