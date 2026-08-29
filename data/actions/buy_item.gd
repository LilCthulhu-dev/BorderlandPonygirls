extends Action
class_name BuyItem

@export var item : Item
@export_range(1, 999, 1) var amount: int = 1
@export var price_factor = Enums.PRICE_TIER.NORMAL

func use():
	if amount == 0:
		return
	else:
		AttributesManager.gold -= _get_price() * amount
		InventoryManager.set_inventory(item, amount)

func requirement_met() -> bool:
	if AttributesManager.gold < _get_price() * amount:
		return false
	if InventoryManager.current_weight + _get_weight_change() > InventoryManager.MAX_WEIGHT:
		return false
	return true

func _get_txt() -> String:
	if amount <= 0 or item == null:
		return ""
	var item_name: String = Utils.translate(item.title)
	var txt: String = Utils.translate("Gain %s %s (%s weight).") % [
		amount, item_name, _get_weight_change()
	]
	txt += "\n"
	txt += Utils.translate("Lose %s Gold.") % (_get_price() * amount)
	return txt

func _get_price() -> int:
	return round(item.price * InventoryManager.PRICE_FACTOR[price_factor])

func _get_weight_change() -> int:
	return item.weight * amount
