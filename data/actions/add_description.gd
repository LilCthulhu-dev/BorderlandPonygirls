extends Action
class_name AddDescription

@export_multiline var txt = ""
@export var rng_text: Array[MultilineText] = []

func get_result() -> String:
	if txt:
		return  Utils.translate(txt)
	rng_text.shuffle()
	return Utils.translate(rng_text[0].text)
