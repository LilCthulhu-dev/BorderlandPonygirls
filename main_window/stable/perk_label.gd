extends Label

var perk : Perk
var ponygirl : Ponygirl
var last_element = false
var pony_mod_bonus = 0

func _ready() -> void:
	pony_mod_bonus = ponygirl.get_mod_bonus()
	text += Utils.translate(perk.name)
	if not last_element:
		text += ", "

func _on_mouse_entered() -> void:
	var tool_tipp_txt = _bonus_text()
	TooltipManager.add(tool_tipp_txt)

func _on_mouse_exited() -> void:
	TooltipManager.remove()

func _bonus_text() -> String:
	var txt = ""
	if perk.bonus:
		if txt != "": txt += "\n"
		var attribute_name = Enums.ATTRIBUTES.keys()[perk.bonus].capitalize()
		txt += "+%s %s" % [pony_mod_bonus, Utils.translate(attribute_name)]
	if perk.malus:
		if txt != "": txt += "\n"
		var attribute_name = Enums.ATTRIBUTES.keys()[perk.malus].capitalize()
		txt += "-5 %s" % Utils.translate(attribute_name)
	if perk.description:
		if txt != "": txt += "\n"
		txt += "%s" % Utils.translate(perk.description)
	return txt
