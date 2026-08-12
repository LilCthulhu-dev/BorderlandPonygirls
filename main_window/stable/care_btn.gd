extends DefaultBtn

enum CARE {
	TRAINING,
	TEASING,
	CLIMAX
}

@export var care_type = CARE.TRAINING

func _ready() -> void:
	super()
	var actions = []
	match care_type:
		CARE.TRAINING:
			actions = GameData.training_actions
		CARE.TEASING:
			actions = GameData.teasing_actions
		CARE.CLIMAX:
			actions = GameData.climax_actions
	disabled = !Utils.requierments_met(actions)
	_add_tooltips(actions)

func _add_tooltips(actions : Array[Action]):
	tooltip = CARE.keys()[care_type].capitalize()
	tooltip += "\n"
	tooltip += "\n".join(TooltipManager.get_tooltips(actions))

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	PonygirlManager.focused_ponygirl = data as Ponygirl
	await get_tree().physics_frame
	match care_type:
		CARE.TRAINING:
			ModalManager.open_care_result_modal(GameData.training_actions)
		CARE.TEASING:
			ModalManager.open_care_result_modal(GameData.teasing_actions)
		CARE.CLIMAX:
			ModalManager.open_care_result_modal(GameData.climax_actions)
	GlobalSignals.update_ponygirls.emit()
