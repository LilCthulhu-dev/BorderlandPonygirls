extends DefaultBtn

var action : CombatAction

func _ready() -> void:
	super()
	set_source_text(action.txt if action else "")
	icon = AttributesManager.get_ability_icon(action.ability)

func _on_pressed() -> void:
	ModalManager.open_combat_result_modal(action)
