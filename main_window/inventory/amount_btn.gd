extends DefaultBtn

@export var amount = 1

func _ready() -> void:
	super()
	GlobalSignals.update_trade_amount.connect(_on_update_trade_amount)
	pressed.connect(_on_pressed)
	button_pressed = InventoryManager.trade_amount == amount
	if amount == 999:
		set_source_text("Max")
	else:
		set_source_text("x%s" % amount)

func _on_pressed():
	InventoryManager.trade_amount = amount

func _on_update_trade_amount():
	button_pressed = InventoryManager.trade_amount == amount
