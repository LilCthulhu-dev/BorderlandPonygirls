extends Action
class_name ChangeGold

@export var amount := ""

func get_amount() -> int:
	return int(Utils.translate(amount))

func use():
	if get_amount() == 0:
		return
	else:
		AttributesManager.gold += get_amount()

func requirement_met() -> bool:
	var value := get_amount()
	return value >= 0 or abs(value) <= AttributesManager.gold

func _get_txt() -> String:
	if get_amount() > 0:
		return Utils.translate("Gain %s gold." % abs(get_amount()))
	elif get_amount() < 0:
		return Utils.translate("Lose %s gold." % abs(get_amount()))
	else:
		return ""
