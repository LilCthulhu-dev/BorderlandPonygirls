extends Resource
class_name CombatManager

const ENEMY_MAX_HEALTH := 3

@export var _current_combat: Combat
@export var _enemy_name := ""
@export var _enemy_health := 0
@export var _current_scene: CombatScene
@export var _last_scene: CombatScene

# ================================================== set/get
static var current_combat: Combat:
	set(value):
		GameData.combat_manager._current_combat = value
	get:
		return GameData.combat_manager._current_combat
static var enemy_name: String:
	set(value):
		GameData.combat_manager._enemy_name = value
	get:
		return GameData.combat_manager._enemy_name
static var enemy_health: int:
	set(value):
		GameData.combat_manager._enemy_health = maxi(value, 0)
	get:
		return GameData.combat_manager._enemy_health
static var current_scene: CombatScene:
	set(value):
		GameData.combat_manager._current_scene = value
	get:
		return GameData.combat_manager._current_scene
static var last_scene: CombatScene:
	set(value):
		GameData.combat_manager._last_scene = value
	get:
		return GameData.combat_manager._last_scene

# ================================================== helper
static func start_combat() -> void:
	enemy_name = current_combat.get_enemy_name()
	enemy_health = ENEMY_MAX_HEALTH
	PonygirlManager.focused_ponygirl = PonygirlManager.get_random_active_ponygirl()
	current_scene = null
	last_scene = null

static func select_next_scene() -> void:
	PonygirlManager.focused_ponygirl = PonygirlManager.get_random_active_ponygirl()
	last_scene = current_scene
	current_scene = current_combat.get_next_scene(last_scene)

static func action_success() -> void:
	enemy_health -= 1

static func action_failure() -> void:
	AttributesManager.current_health -= 1

static func victory() -> void:
	for action in current_combat.victory_actions:
		action.use()

static func defeat() -> void:
	if current_combat.defeat_actions.is_empty():
		AttributesManager.gold -= GameData.COSTS.death
		for pony in PonygirlManager.ponygirls:
			if pony.active:
				pony.loyalty -= 10
		LocationManager.current_location = LocationManager.home_location
	else:
		for action in current_combat.defeat_actions:
			action.use()

static func get_victory_txt() -> String:
	var txt: String = Utils.translate(current_combat.victory_txt)
	txt += "\n"
	for action in current_combat.victory_actions:
		txt += "\n" + action.get_result()
	return txt

static func get_defeat_txt() -> String:
	var txt: String = Utils.translate(current_combat.defeat_txt)
	txt += "\n"
	if current_combat.defeat_actions.is_empty():
		txt += "\n" + (Utils.translate("- Lose %s Gold") % GameData.COSTS.death)
		txt += "\n" + (Utils.translate("- All active ponygirls lose %s loyalty") % 10)
		txt += "\n" + Utils.translate("- Retreat back to your Home Village.")
	else:
		for action in current_combat.defeat_actions:
			var result := action.get_result()
			if not result.is_empty():
				txt += "\n" + result
	return txt
