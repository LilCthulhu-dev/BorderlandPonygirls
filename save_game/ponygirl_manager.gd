extends Resource
class_name PonygirlManager

const FIRST_NAMES := [
	"Sugar",
	"Puffy",
	"Horny",
	"Milky",
	"Needy",
	"Bouncy",
	"Juicy",
	"Slutty",
	"Dirty",
	"Naughty",
	"Kinky",
	"Wet",
	"Tasty",
	"Sassy",
	"Cheeky",
    "Lusty"
]
const LAST_NAMES := [
	"Tits",
	"Cunt",
	"Pussy",
	"Eyes",
	"Lips",
	"Ass",
	"Booty",
	"Cheeks",
	"Hips",
	"Thighs",
    "Legs"
]
const EYE_COLORS := [
	"Brown",
	"Hazel",
	"Amber",
	"Green",
	"Emerald",
	"Blue",
	"Gray",
	"Violet",
	"Red",
	"Crimson",
	"Gold",
	"Silver",
	"Black"
]
const HAIR_COLORS := [
	"Black",
	"Brown",
	"Chestnut",
	"Auburn",
	"Red",
	"Ginger",
	"Blonde",
	"White",
	"Gray",
	"Silver"
]
const SKIN_TONES := [
	"Pale",
	"Fair",
	"Light",
	"Tan",
	"Olive",
	"Bronze",
	"Brown",
	"Ebony",
	"Ashen",
	"Golden",
    "Porcelain"
]
const PORTRAITS := {
	Enums.PONYGIRL_RACES.HUMAN: [
		preload("res://assets/img/ponygirls/human_01.png"),
		preload("res://assets/img/ponygirls/human_02.png"),
		preload("res://assets/img/ponygirls/human_03.png"),
		preload("res://assets/img/ponygirls/human_04.png"),
		preload("res://assets/img/ponygirls/human_05.png"),
		preload("res://assets/img/ponygirls/human_08.png"),
		preload("res://assets/img/ponygirls/human_09.png")
	],
	Enums.PONYGIRL_RACES.ELF: [
		preload("res://assets/img/ponygirls/elf_01.png"),
		preload("res://assets/img/ponygirls/elf_02.png"),
		preload("res://assets/img/ponygirls/elf_03.png"),
		preload("res://assets/img/ponygirls/elf_04.png")
	],
	Enums.PONYGIRL_RACES.TIEFLING: [
		preload("res://assets/img/ponygirls/tiefling_01.png"),
		preload("res://assets/img/ponygirls/tiefling_02.png")
	],
}
const MAX_ACTIVE := 4
const MAX_RESTING := 4
const MAX_TOTAL := MAX_ACTIVE + MAX_RESTING

@export var _ponygirls: Array[Ponygirl] = []
@export var _focused_ponygirl: Ponygirl = null

# ================================================== set/get
static var ponygirls: Array[Ponygirl]:
	set(value):
		GameData.ponygirl_manager._ponygirls = value
	get:
		return GameData.ponygirl_manager._ponygirls

static var focused_ponygirl: Ponygirl:
	set(value):
		GameData.ponygirl_manager._focused_ponygirl = value
	get:
		return GameData.ponygirl_manager._focused_ponygirl

# ================================================== helper
static func get_active_ponygirls() -> Array[Ponygirl]:
	var active_ponygirls: Array[Ponygirl] = []
	for pony in ponygirls:
		if pony.active:
			active_ponygirls.append(pony)
	return active_ponygirls

static func get_resting_ponygirls() -> Array[Ponygirl]:
	var resting_ponygirls: Array[Ponygirl] = []
	for pony in ponygirls:
		if not pony.active:
			resting_ponygirls.append(pony)
	return resting_ponygirls

static func get_random_active_ponygirl() -> Ponygirl:
	var active_ponygirls := get_active_ponygirls()
	if active_ponygirls.is_empty():
		return null
	return active_ponygirls.pick_random()

static func get_random_resting_ponygirl() -> Ponygirl:
	var resting_ponygirls := get_resting_ponygirls()
	if resting_ponygirls.is_empty():
		return null
	return resting_ponygirls.pick_random()

static func get_perk_by_name(perk_name: StringName) -> Perk:
	for perk in GameData.list_of_perks:
		if perk.name == perk_name:
			return perk
	return null

static func active_slots_free() -> bool:
	var number := 0
	for pony in ponygirls:
		if pony.active:
			number += 1
	return number < MAX_ACTIVE

static func resting_slots_free() -> bool:
	var number := 0
	for pony in ponygirls:
		if not pony.active:
			number += 1
	return number < MAX_RESTING

static func slots_free() -> bool:
	return ponygirls.size() < MAX_TOTAL

static func add_ponygirl(pony: Ponygirl) -> void:
	if pony == null:
		push_error("PonygirlManager.add_ponygirl: pony is null")
		return
	if not slots_free():
		return
	var new_pony := pony.duplicate(true) as Ponygirl
	new_pony.init()
	new_pony.active = active_slots_free()
	ponygirls.append(new_pony)
	focused_ponygirl = new_pony


## Fully configured instance (no second init). Used by quest-mare keep.
static func add_ponygirl_instance(pony: Ponygirl) -> void:
	if pony == null:
		push_error("PonygirlManager.add_ponygirl_instance: pony is null")
		return
	if not slots_free():
		return
	if pony.id.is_empty():
		pony.id = str(ResourceUID.create_id())
	pony.active = active_slots_free()
	ponygirls.append(pony)
	focused_ponygirl = pony
