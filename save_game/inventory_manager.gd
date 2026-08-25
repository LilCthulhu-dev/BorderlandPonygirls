extends Resource
class_name InventoryManager

# Price multiplier if item is...
# Shops carry cheap and expensive items, very_cheap is only relevant for quests.

const PRICE_FACTOR : Dictionary = {
	Enums.PRICE_TIER.VERY_CHEAP: 0.7,
	Enums.PRICE_TIER.CHEAP: 0.85,
	Enums.PRICE_TIER.NORMAL: 1.0,
	Enums.PRICE_TIER.EXPENSIVE: 1.15,
}
const MAX_WEIGHT = 25

@export var _inventory: Dictionary[StringName, Item] = {}
@export var _trade_amount: int = 1

# ================================================== set/get
static var inventory: Dictionary[StringName, Item]:
	set(value):
		GameData.inventory_manager._inventory = value
	get:
		return GameData.inventory_manager._inventory

static var current_weight : int:
	get:
		var weight = 0
		for item: Item in inventory.values():
			weight += item.amount * item.weight
		for flag: Flag in FlagsManager.flags.values():
			weight += flag.weight
		return weight

static var trade_amount: int:
	set(value):
		GameData.inventory_manager._trade_amount = value
		GlobalSignals.update_trade_amount.emit()
	get:
		return GameData.inventory_manager._trade_amount

# ================================================== helper
static func set_inventory(item: Item, amount: int) -> void:
	var id := item.id
	if inventory.has(id):
		inventory[id].amount += amount
	else:
		inventory[id] = item.duplicate(true) as Item
		inventory[id].amount = amount
	if inventory.has(id) and inventory[id].amount <= 0:
		inventory.erase(id)
	GlobalSignals.update_inventory.emit()

static func get_local_price(item: Item) -> int:
	var location := LocationManager.current_location
	var price_factor := PRICE_FACTOR[Enums.PRICE_TIER.NORMAL] as float
	for local_item: Item in location.cheap_items:
		if local_item.id == item.id:
			price_factor = PRICE_FACTOR[Enums.PRICE_TIER.CHEAP]
			break
	for local_item: Item in location.expensive_items:
		if local_item.id == item.id:
			price_factor = PRICE_FACTOR[Enums.PRICE_TIER.EXPENSIVE]
			break
	return int(round(item.price * price_factor))
