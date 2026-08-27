extends Action
class_name AddDescription

@export_multiline var txt = ""
@export var rng_text: Array[MultilineText] = []

func use() -> void:
	return

func get_result() -> String:
	if rng_text:
		rng_text.shuffle()
		return rng_text[0].text
	else:
		return txt
