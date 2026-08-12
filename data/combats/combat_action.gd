extends Resource
class_name CombatAction

@export var txt := ""
@export var ability := Enums.ABILITIES.WITS
@export_multiline var success_description : String
@export_multiline var fail_description : String

func check(difficulty_penalty: int = 0) -> bool:
	var dice_roll: int = Utils.roll_dice(100)
	var target_value: int = AttributesManager.get_ability_value(ability)
	target_value -= difficulty_penalty
	return dice_roll <= clampi(target_value, 0, 100)
