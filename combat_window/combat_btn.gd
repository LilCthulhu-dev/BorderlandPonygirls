extends DefaultBtn

var action : CombatAction

func _ready() -> void:
	super()
	text = action.txt
	icon = AttributesManager.get_ability_icon(action.ability)

func _on_pressed() -> void:
	ModalManager.open_combat_result_modal(action)
