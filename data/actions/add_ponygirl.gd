extends Action
class_name AddPonygirl

@export var ponygirl : Ponygirl = preload("res://data/ponygirls/default_pony.tres")

func use():
	PonygirlManager.add_ponygirl(ponygirl)

func requirement_met() -> bool:
	return PonygirlManager.slots_free()

func get_tooltip() -> String:
	return Utils.translate("Add a ponygirl to your stable.")

func get_result() -> String:
	var pony_name = Ponygirl.get_random_name()
	ponygirl.name = pony_name
	return Utils.translate("- Add ponygirl %s to your stable" % pony_name)
