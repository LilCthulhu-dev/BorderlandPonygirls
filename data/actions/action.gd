extends Resource
class_name Action

@export_group('Requierments')
@export var hide_tooltip := false
@export var hide_description : = false
@export var hard_requierment := false

func use() -> void:
	var result := get_result().strip_edges()
	if not result.is_empty():
		GlobalSignals.add_info.emit(result)

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
