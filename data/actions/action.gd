extends Resource
class_name Action

@export var hide_tooltip := false
@export var hide_description : = false
@export var hard_requierment := false

func use() -> void:
	pass

func requirement_met() -> bool:
	return true

func _get_txt() -> String:
	return ""

func get_tooltip() -> String:
	if hide_tooltip: return ""
	return Utils.translate(_get_txt())

func get_result() -> String:
	if hide_description: return ""
	var txt := _get_txt()
	if txt.is_empty(): return ""
	txt = txt.replace("\n", "\n- ")
	return Utils.translate("- " + txt)
