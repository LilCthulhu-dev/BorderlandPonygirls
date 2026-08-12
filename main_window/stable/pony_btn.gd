extends DefaultBtn

var ponygirl : Ponygirl
var active_btn = false

func _ready() -> void:
	super()
	if ponygirl:
		_add_tooltips()
		text = "%s" % ponygirl.name
	else:
		text = "-"

func _add_tooltips() -> void:
	tooltip = "%s (Level %s %s)" % [
		ponygirl.name,
		ponygirl.level,
		ponygirl.race]
	tooltip += "\n\n"
	tooltip += "XP: %s / Arousal: %s / Loyalty: %s" % [
		ponygirl.xp,
		ponygirl.arousal,
		ponygirl.loyalty]
	tooltip += "\n"
	tooltip += "Eyes: %s / Hair: %s / Skin: %s" % [
		ponygirl.eye_color,
		ponygirl.hair_color,
		ponygirl.skin_tone]
	tooltip += "\n"

	var perk_descriptions: Array[String] = []
	for perk in ponygirl.perks:
		var modifiers := perk.get_full_description(ponygirl)
		if modifiers.is_empty(): continue
		perk_descriptions.append("%s: %s" % [perk.name, " / ".join(modifiers)])
	if not perk_descriptions.is_empty():
		tooltip += "\n" + "\n".join(perk_descriptions)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if ponygirl == null: return null
	var preview := duplicate()
	var preview_root := Control.new()
	preview.size = size
	preview.ponygirl = ponygirl
	preview.set_anchors_preset(Control.PRESET_TOP_LEFT)
	preview.position = -preview.size / 2.0
	preview.modulate.a = 0.5
	preview_root.add_child(preview)
	set_drag_preview(preview_root)
	return ponygirl

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is not Ponygirl: return false
	var pony := data as Ponygirl
	if active_btn:
		if pony.active:
			return false
		return PonygirlManager.active_slots_free()
	if not pony.active:
		return false
	return PonygirlManager.resting_slots_free()

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var pony := data as Ponygirl
	pony.active = active_btn
	GlobalSignals.update_ponygirls.emit()

func _on_pressed() -> void:
	if ponygirl:
		ModalManager.open_ponygirl_modal(ponygirl)
