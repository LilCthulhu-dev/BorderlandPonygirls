extends Resource
class_name FlagsManager

@export var _flags: Dictionary[StringName, Flag] = {}

# ================================================== set/get
static var flags: Dictionary[StringName, Flag]:
	set(value):
		GameData.flags_manager._flags = value
	get:
		return GameData.flags_manager._flags

# ================================================== helper
static func add_flag(flag: Flag) -> void:
	if flags.has(flag.id):
		return
	if flag.weight > 0:
		var txt := "You gained %s weight." % flag.weight
		GlobalSignals.add_info.emit(txt)
	flags[flag.id] = flag

static func remove_flag(flag: Flag) -> void:
	if not flags.has(flag.id):
		return
	if flag.weight > 0:
		var txt := "You lost %s weight." % flag.weight
		GlobalSignals.add_info.emit(txt)
	flags.erase(flag.id)

static func has_flag(flag: Flag) -> bool:
	return flags.has(flag.id)
