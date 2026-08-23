extends DefaultBtn

var ponygirl : Ponygirl
var slot_index := -1

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
	tooltip += "XP: %s / Arousal: %s / Submission: %s" % [
		ponygirl.xp,
		ponygirl.arousal,
		ponygirl.submission]
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
	return {
		"ponygirl": ponygirl,
		"slot_index": slot_index
	}

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return (
		data is Dictionary
		and data.has("slot_index")
		and data.slot_index != slot_index
	)

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var source_slot: int = data.slot_index
	PonygirlManager.swap_slots(source_slot, slot_index)
	GlobalSignals.update_ponygirls.emit()

func _on_pressed() -> void:
	if ponygirl:
		ModalManager.open_ponygirl_modal(ponygirl)
