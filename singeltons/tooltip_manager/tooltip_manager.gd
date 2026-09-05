extends Node

var tooltipp_bp = preload("res://templates/tooltipp.tscn")
var tooltips : Array[Tooltip]

func add(txt) -> void:
	var t = tooltipp_bp.instantiate()
	t.txt = Utils.translate(txt)
	add_child(t)
	tooltips.push_front(t)

func remove() -> void:
	for t in tooltips:
		t.queue_free()
	tooltips.clear()

func get_tooltips_from_actions(actions : Array[Action]):
	var arr : Array[String]
	for action in actions:
		if action.get_tooltip() == "": continue
		arr.push_back(action.get_tooltip())
	return "\n".join(arr)

func get_tooltips(actions : Array[Action]) -> Array[String]:
	var arr : Array[String]
	for action in actions:
		if action.get_tooltip() == "": continue
		arr.push_back(action.get_tooltip())
	return arr
