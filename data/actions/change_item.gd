extends Action
class_name ChangeItem

@export var item : Item
@export var amount := 0

func use():
	if item == null or amount == 0: return
	super()
	InventoryManager.set_inventory(item, amount)

func requirement_met() -> bool:
	if item == null:
		return false
	if InventoryManager.current_weight + _get_weight_change() > InventoryManager.MAX_WEIGHT:
		return false
	return true

func _get_txt() -> String:
	if item == null:
		return ""
	if amount > 0:
		return Utils.translate("Gain %s %s (%s weight)." % [abs(amount), item.title, _get_weight_change()])
	elif amount < 0:
		return Utils.translate("Lose %s %s." % [abs(amount), item.title])
	else:
		return ""

func _get_weight_change():
	return item.weight * amount
