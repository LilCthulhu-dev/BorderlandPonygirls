extends Node

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	randomize()

func requierments_met(actions : Array[Action]) -> bool:
	for action in actions:
		if not action.requirement_met():
			return false
	return true

func string_to_id(text: String) -> String:
	var id := text.to_lower().strip_edges()
	id = id.replace(" ", "_")
	var regex := RegEx.new()
	regex.compile("[^a-z0-9_]")
	id = regex.sub(id, "", true)
	return id

func translate(text : String) -> String:
	if !GameData.attributes_manager: return text
	if !GameData.combat_manager: return text
	if !GameData.ponygirl_manager: return text

	var ponygirl : Ponygirl = PonygirlManager.focused_ponygirl
	var pony_name : String = ponygirl.name if ponygirl != null else ""
	var replacements := {
		"{TITLE}": AttributesManager.boss_title,
		"{NAME}": AttributesManager.boss_name,
		"{PONYNAME}": pony_name,
		"{ENEMY_NAME}": CombatManager.enemy_name,

		"{GOOD_WAGE}": GameData.COSTS.good_wage,
		"{MEDIUM_WAGE}": GameData.COSTS.medium_wage,
		"{BAD_WAGE}": GameData.COSTS.bad_wage,

		"{COST_DEATH}": GameData.COSTS.death,
		"{COST_REST}": GameData.COSTS.rest,
		"{COST_TRAVEL}": GameData.COSTS.travel,
		"{COST_CHEAP_PONYGIRL}": GameData.COSTS.ponygirl_cheap,
		"{COST_PONYGIRL}": GameData.COSTS.ponygirl_normal,
		"{COST_EXPENSIVE_PONYGIRL}": GameData.COSTS.ponygirl_expensive,
		"{COST_TRAINING}": GameData.COSTS.training,
		"{COST_TEASING}": GameData.COSTS.teasing,
		"{COST_CLIMAX}": GameData.COSTS.climax,
	}
	for key in replacements:
		text = text.replace(key, str(replacements[key]))
	return text

func roll_dice(max_number := 100):
	return rng.randi_range(1, max_number)

func clear_container(container: Container) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
