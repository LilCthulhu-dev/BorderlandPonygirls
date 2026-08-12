extends Action
class_name ChangeRepute

@export var amount := 0

func use():
	if amount == 0: return
	AttributesManager.repute += amount

func _get_txt() -> String:
	if amount > 0:
		return Utils.translate("Gain %s repute." % abs(amount))
	elif amount < 0:
		return Utils.translate("Lose %s repute." % abs(amount))
	else:
		return ""
