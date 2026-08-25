extends Action
class_name FlagAction

@export var add_flag: Array[Flag]
@export var remove_flag: Array[Flag]
@export var required_flag: Array[Flag]
@export var requires_one_flag: Array[Flag]
@export var forbidden_flag: Array[Flag]

func use() -> void:
	for flag in add_flag:
		FlagsManager.add_flag(flag)
	for flag in remove_flag:
		FlagsManager.remove_flag(flag)

func _get_weight_change() -> int:
	var weight_change := 0
	for flag in add_flag:
		if not FlagsManager.has_flag(flag):
			weight_change += flag.weight
	for flag in remove_flag:
		if FlagsManager.has_flag(flag):
			weight_change -= flag.weight
	return weight_change

func _get_txt() -> String:
	var weight_change := _get_weight_change()
	if weight_change > 0:
		return "Add %s weight" % weight_change
	elif  weight_change < 0:
		return "Remove %s weight" % abs(weight_change)
	return ""

func requirement_met() -> bool:
	# weight
	var weight_change := _get_weight_change()
	if InventoryManager.current_weight + weight_change > InventoryManager.MAX_WEIGHT:
		return false

	# forbidden
	for flag in forbidden_flag:
		if FlagsManager.has_flag(flag):
			return false

	# required
	for flag in required_flag:
		if not FlagsManager.has_flag(flag):
			return false
	if not requires_one_flag.is_empty():
		var has_one_required_flag := false
		for flag in requires_one_flag:
			if FlagsManager.has_flag(flag):
				has_one_required_flag = true
				break
		if not has_one_required_flag:
			return false
	return true
