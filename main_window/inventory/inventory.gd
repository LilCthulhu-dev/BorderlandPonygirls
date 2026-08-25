extends StoryPage

@onready var shop_header: Label = %ShopHeader
@onready var iventory_grid: GridContainer = %IventoryGrid
@onready var quest_item_label: Label = %QuestItemLabel
@onready var quest_item_grid: GridContainer = %QuestItemGrid
@onready var shop_grid: GridContainer = %ShopGrid

const ITEM_BTN = preload("uid://dsletyanr45si")
const QUEST_ICON = preload("uid://c3jxucw5l3to6")
var amount = 1

func _ready():
	super()
	GlobalSignals.update_inventory.connect(_update_all)

func _on() -> void:
	super()
	_update_all()
	_update_quest_items()

func _update_all():
	_update_warband()
	_update_shop()

func _update_quest_items():
	Utils.clear_container(quest_item_grid)
	_add_quest_icons()
	quest_item_label.visible = quest_item_grid.get_child_count() > 0

func _update_warband():
	Utils.clear_container(iventory_grid)
	for id in InventoryManager.inventory.keys():
		var item = InventoryManager.inventory[id]
		_add_item_btn(item, false)

func _add_quest_icons() -> void:
	for flag: Flag in FlagsManager.flags.values():
		if not flag.add_quest_icon():
			continue
		if flag.weight == 0:
			continue
		var icon = QUEST_ICON.instantiate()
		icon.flag = flag
		quest_item_grid.add_child(icon)

func _update_shop():
	shop_header.text = LocationManager.current_location.title
	Utils.clear_container(shop_grid)
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
		iventory_grid.add_child(btn)
