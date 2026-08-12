extends Resource
class_name FlagsManager

@export var _flags: Dictionary[StringName, bool] = {}

# ================================================== set/get
static var flags: Dictionary[StringName, bool]:
	set(value):
		GameData.flags_manager._flags = value
	get:
		return GameData.flags_manager._flags

# ================================================== helper
static func add_flag(flag: Flag) -> void:
	flags[flag.id] = true

static func remove_flag(flag: Flag) -> void:
	flags.erase(flag.id)

static func has_flag(flag: Flag) -> bool:
	return flags.get(flag.id, false)
