extends Resource
class_name CombatScene

@export var img : Texture2D
@export var flavor_lines : Array[String]
@export_multiline var description := ""
@export var actions : Array[CombatAction]

func get_actions() -> Array[CombatAction]:
	var shuffled_actions := actions.duplicate()
	shuffled_actions.shuffle()
	var selected_actions: Array[CombatAction] = []
	for action in shuffled_actions:
		selected_actions.append(action)
		if selected_actions.size() >= 2: break
	return selected_actions
