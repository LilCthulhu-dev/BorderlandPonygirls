extends Node
class_name Enums

enum ATTRIBUTES {
	NONE,
	MUSCLE,
	SWAY,
	COMMAND,
	TRICKERY,
	WITS,
	GOLD,
	HEALTH,
	REPUTE,
	WEIGHT
}
enum PONYGIRL_RACES {
	UNKNOWN,
	HUMAN,
	ELF,
	DEMONBLOOD
}
enum ABILITIES {
	NONE,
	MUSCLE,
	SWAY,
	COMMAND,
	TRICKERY,
	WITS,
}
enum PRICE_TIER {
	VERY_CHEAP,
	CHEAP,
	NORMAL,
	EXPENSIVE,
}
enum GAME_STATES {
	NONE,
	START,
	MAIN,
	EVENT,
	COMBAT,
	OPTIONS,
	TRAVEL,
	MODAL,
	SCENE_CHANGE
}

# ================================================== helper
static func enum_to_name(enum_dict: Dictionary, value: int) -> String:
	var key = enum_dict.find_key(value)
	if key == null:
		return ""
	return str(key).capitalize()


static func ability_enum_to_name(ability: ABILITIES) -> String:
	return enum_to_name(ABILITIES, ability)


static func attribute_enum_to_name(attribute: ATTRIBUTES) -> String:
	return enum_to_name(ATTRIBUTES, attribute)

static func ability_to_attribute(ability: ABILITIES) -> ATTRIBUTES:
	match ability:
		ABILITIES.MUSCLE:
			return ATTRIBUTES.MUSCLE
		ABILITIES.WITS:
			return ATTRIBUTES.WITS
		ABILITIES.TRICKERY:
			return ATTRIBUTES.TRICKERY
		ABILITIES.SWAY:
			return ATTRIBUTES.SWAY
		ABILITIES.COMMAND:
			return ATTRIBUTES.COMMAND
		_:
			return ATTRIBUTES.NONE

static func attribute_to_ability(attribute: ATTRIBUTES) -> ABILITIES:
	match attribute:
		ATTRIBUTES.MUSCLE:
			return ABILITIES.MUSCLE
		ATTRIBUTES.SWAY:
			return ABILITIES.SWAY
		ATTRIBUTES.COMMAND:
			return ABILITIES.COMMAND
		ATTRIBUTES.TRICKERY:
			return ABILITIES.TRICKERY
		ATTRIBUTES.WITS:
			return ABILITIES.WITS
		_:
			return ABILITIES.NONE
