extends Action
class_name BuyItem

@export var item : Item
@export_range(1, 999, 1) var amount: int = 1
@export var price = Enums.PRICE_TIER.NORMAL

func use():
	if amount == 0:
		return
	else:
		AttributesManager.gold -= InventoryManager.get_local_price(item)
		InventoryManager.set_inventory(item, amount)

func _get_txt() -> String:
	var local_price = InventoryManager.get_local_price(item)
	if amount > 0:
		var item_name: String = Utils.translate(item.title) if item else ""
		var txt: String = Utils.translate("Gain %s %s.") % [abs(amount), item_name]
		txt += "\n"
		txt += Utils.translate("Lose %s Gold.") % local_price
		return txt
	else:
		return ""
