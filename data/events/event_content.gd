extends Resource
class_name _EventContent

@export_group('uses')
@export var single_use = false
@export var used = false

func soft_requirements_met() -> bool:
	return true

func hard_requierments_met() -> bool:
	return true
