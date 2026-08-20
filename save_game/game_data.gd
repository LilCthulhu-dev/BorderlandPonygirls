extends Node

# ================================================== game balance values
const REWARDS = {
	good_wage = 300,
	medium_wage = 250,
	bad_wage = 200,
	price_money = 400,
	victory = 250,
}

const COSTS = {
	rest = 25,
	travel = 0.1, # per pixel
	death = 200,
	ponygirl_cheap = 60,
	ponygirl_normal = 80,
	ponygirl_expensive = 100,
	training = 300,
	teasing = 25,
	climax = 50,
	racing_gear = 500,
	race_fee = 200,
}

@export_group("Actions")
@export var combat_victory_actions : Array[Action]
@export var combat_defeat_actions : Array[Action]

@export var training_actions : Array[Action]
@export var teasing_actions : Array[Action]
@export var climax_actions : Array[Action]
@export var list_of_perks :Array[Perk] = []

# ================================================== game state
var TESTING = false

var old_game_state = Enums.GAME_STATES.NONE
var game_state = Enums.GAME_STATES.START:
	set(value):
		old_game_state = game_state
		game_state = value
		GlobalSignals.game_state_changed.emit()

# ================================================== save / manager
var save_game: SaveGame = SaveGame.new()
var attributes_manager : AttributesManager:
	set(value):
		save_game.attributes_manager = value
	get:
		return save_game.attributes_manager
var combat_manager : CombatManager:
	set(value):
		save_game.combat_manager = value
	get:
		return save_game.combat_manager
var flags_manager : FlagsManager:
	set(value):
		save_game.flags_manager = value
	get:
		return save_game.flags_manager
var inventory_manager : InventoryManager:
	set(value):
		save_game.inventory_manager = value
	get:
		return save_game.inventory_manager
var location_manager : LocationManager:
	set(value):
		save_game.location_manager = value
	get:
		return save_game.location_manager
var ponygirl_manager : PonygirlManager:
	set(value):
		save_game.ponygirl_manager = value
	get:
		return save_game.ponygirl_manager
