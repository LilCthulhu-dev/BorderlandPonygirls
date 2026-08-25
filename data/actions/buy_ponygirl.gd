extends AddPonygirl
class_name BuyPonygirl

@export var _price := Enums.PONY_PRICES.NORMAL
@export_multiline var description := ""
var price:
	set(value):
		_price = value
	get:
		return Enums.get_pony_price(_price)

func use() -> void:
	super()
	AttributesManager.gold -= price

func requirement_met() -> bool:
	var can_pay = price as int <= AttributesManager.gold
	var free_slot = PonygirlManager.slots_free()
	return can_pay and free_slot

func get_tooltip() -> String:
	var txt := [
		"Lose %s gold." % price,
		"Add a ponygirl to your stable."
	]
	return "\n".join(txt)

func get_result() -> String:
	var txt := [
		"- Lose %s gold." % price,
		"- Add ponygirl %s to your stable." % _get_name()
	]
	if not description.is_empty():
		txt.push_front("")
		txt.push_front(description)
	return "\n".join(txt)
