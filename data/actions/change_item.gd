extends Action
class_name ChangeItem

@export var item : Item
@export var amount := 0

func use():
	if amount == 0:
		return
	else:
		InventoryManager.set_inventory(item, amount)

func _get_txt() -> String:
	if amount > 0:
		var item_name: String = Utils.translate(item.title) if item else ""
		return Utils.translate("Gain %s %s.") % [abs(amount), item_name]
	elif amount < 0:
		var item_name: String = Utils.translate(item.title) if item else ""
		return Utils.translate("Lose %s %s.") % [abs(amount), item_name]
	else:
		return ""
