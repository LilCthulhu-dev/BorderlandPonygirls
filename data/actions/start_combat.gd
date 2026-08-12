extends Action
class_name StartCombat

@export var combat : Combat

func use() -> void:
	CombatManager.current_combat = combat
	CombatManager.start_combat()
	SceneManager.change_scene(SceneManager.COMBAT_WINDOW)

func requirement_met() -> bool:
	return AttributesManager.current_health > 0

func get_tooltip() -> String:
	if hide_tooltip: return ""
	return Utils.translate("Start combat. Requires at least 1 Health.")
