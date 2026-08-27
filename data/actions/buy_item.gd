extends Action
class_name BuyItem

@export var item : Item
@export_range(1, 999, 1) var amount: int = 1
@export var price_factor = Enums.PRICE_TIER.NORMAL

func use():
	if amount == 0: return
	super()
	AttributesManager.gold -= _get_price() * amount
	InventoryManager.set_inventory(item, amount)

func requirement_met() -> bool:
	if AttributesManager.gold < _get_price() * amount:
		return false
	if InventoryManager.current_weight + _get_weight_change() > InventoryManager.MAX_WEIGHT:
		return false
	return true

func _get_txt() -> String:
	var total_price := _get_price() * amount
	var txt := ""
	txt += "Gain %s %s (%s weight)." % [amount, item.title, _get_weight_change()]
	txt += "\n"
	txt += "Lose %s Gold." % total_price
	return Utils.translate(txt)

func _get_price() -> int:
	return round(item.price * InventoryManager.PRICE_FACTOR[price_factor])

func _get_weight_change() -> int:
	return item.weight * amount
