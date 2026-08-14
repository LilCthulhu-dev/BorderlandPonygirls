extends StoryPage

@onready var shop_header: Label = %ShopHeader
@onready var player_grid: GridContainer = %PlayerGrid
@onready var shop_grid: GridContainer = %ShopGrid

const ITEM_BTN = preload("uid://dsletyanr45si")
var amount = 1

func _ready():
	super()
	GlobalSignals.update_inventory.connect(_update_all)

func _on() -> void:
	super()
	_update_all()

func _update_all():
	_update_warband()
	_update_shop()

func _update_warband():
	for child in player_grid.get_children():
		child.queue_free()
	for id in InventoryManager.inventory.keys():
		var item = InventoryManager.inventory[id]
		_add_item_btn(item, false)

func _update_shop():
	Utils.set_dynamic_label(shop_header, LocationManager.current_location.title)
	for child in shop_grid.get_children():
		child.queue_free()
	for item in LocationManager.current_location.cheap_items:
		_add_item_btn(item)
	for item in LocationManager.current_location.expensive_items:
		_add_item_btn(item)

func _add_item_btn(item, shop = true):
	var btn = ITEM_BTN.instantiate()
	btn.item = item
	btn.shop = shop
	if shop:
		shop_grid.add_child(btn)
	else:
		player_grid.add_child(btn)
