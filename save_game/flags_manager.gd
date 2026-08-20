extends Resource
class_name FlagsManager

@export var _flags: Dictionary[StringName, Flag] = {}
@export var _quest_ponygirl: Ponygirl = null

# ================================================== set/get
static var flags: Dictionary[StringName, Flag]:
	set(value):
		GameData.flags_manager._flags = value
	get:
		return GameData.flags_manager._flags
static var quest_ponygirl: Ponygirl:
	set(value):
		GameData.flags_manager._quest_ponygirl = value
	get:
		return GameData.flags_manager._quest_ponygirl

# ================================================== helper
static func add_flag(flag: Flag) -> void:
	flags[flag.id] = flag

static func remove_flag(flag: Flag) -> void:
	flags.erase(flag.id)

static func has_flag(flag: Flag) -> bool:
	return flags.has(flag.id)

static func quest_ponygirl_name() -> String:
	if quest_ponygirl == null:
		return ""
	return quest_ponygirl.name

static func set_quest_ponygirl(pony: Ponygirl) -> void:
	quest_ponygirl = pony
	if pony != null:
		PonygirlManager.focused_ponygirl = pony

static func clear_quest_ponygirl() -> void:
	quest_ponygirl = null
