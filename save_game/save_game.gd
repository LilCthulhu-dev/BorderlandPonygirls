
extends Resource
class_name SaveGame

const SAVE_GAME_PATH := "user://save_%s.tres"
const SAVE_INFO_PATH := "user://save_%s_info.tres"

@export var attributes_manager : AttributesManager
@export var combat_manager : CombatManager
@export var flags_manager : FlagsManager
@export var inventory_manager : InventoryManager
@export var location_manager : LocationManager
@export var ponygirl_manager : PonygirlManager
@export var save_date := ""

# ================================================== save and load
static func new_game(new_boss_name: String, new_boss_title: String) -> void:
	var home_location = load("res://data/locations/goblin_village.tres") as Location
	var start_pony = load("res://data/ponygirls/starter_pony.tres") as Ponygirl

	GameData.save_game = SaveGame.new()
	GameData.attributes_manager = AttributesManager.new()
	GameData.combat_manager = CombatManager.new()
	GameData.flags_manager = FlagsManager.new()
	GameData.inventory_manager = InventoryManager.new()
	GameData.location_manager = LocationManager.new()
	GameData.ponygirl_manager = PonygirlManager.new()

	PonygirlManager.init()
	AttributesManager.boss_name = new_boss_name
	AttributesManager.boss_title = new_boss_title
	PonygirlManager.add_ponygirl(start_pony)
	LocationManager.home_location = home_location
	LocationManager.current_location = home_location


static func save(slot_number: int = 0) -> void:
	var path := get_save_path(slot_number)
	GameData.save_game.save_date = get_current_date()
	ResourceSaver.save(
		GameData.save_game,
		path
	)
	var save_info := SaveInfo.new()
	save_info.save_date = GameData.save_game.save_date
	save_info.boss_name = AttributesManager.boss_name
	save_info.boss_title = AttributesManager.boss_title
	ResourceSaver.save(save_info, get_save_info_path(slot_number))

static func load(slot_number: int = 0) -> SaveGame:
	var path := get_save_path(slot_number)
	if not ResourceLoader.exists(path):
		return null
	var save_game := ResourceLoader.load(
		path,
		"",
		ResourceLoader.CACHE_MODE_IGNORE
	) as SaveGame
	if save_game == null:
		return null
	GameData.save_game = save_game
	GameData.attributes_manager = save_game.attributes_manager
	GameData.combat_manager = save_game.combat_manager
	GameData.flags_manager = save_game.flags_manager
	GameData.inventory_manager = save_game.inventory_manager
	GameData.location_manager = save_game.location_manager
	GameData.ponygirl_manager = save_game.ponygirl_manager
	return save_game

static func load_info(slot_number: int) -> SaveInfo:
	var path := get_save_info_path(slot_number)
	if not ResourceLoader.exists(path):
		return null
	return ResourceLoader.load(
		path,
		"",
		ResourceLoader.CACHE_MODE_IGNORE
	) as SaveInfo

# ================================================== helper
static func get_save_path(slot_number: int) -> String:
	return SAVE_GAME_PATH % slot_number

static func get_save_info_path(slot_number: int) -> String:
	return SAVE_INFO_PATH % slot_number

static func save_exists(slot_number: int) -> bool:
	return ResourceLoader.exists(
		get_save_path(slot_number)
	)

static func get_current_date() -> String:
	var date := Time.get_datetime_dict_from_system()

	return "%02d.%02d.%04d - %02d:%02d" % [
		date.day,
		date.month,
		date.year,
		date.hour,
		date.minute,
	]
