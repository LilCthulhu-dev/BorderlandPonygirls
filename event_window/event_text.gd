extends Label

var content : _EventContent

func _ready() -> void:
	if content is EventText:
		text = Utils.translate((content as EventText).txt)
	elif content != null and "txt" in content:
		text = Utils.translate(str(content.txt))
	else:
		text = ""
