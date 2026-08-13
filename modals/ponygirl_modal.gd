extends Modal

@onready var titel_label: Label = %TitelLabel
@onready var portrait: TextureRect = %portrait
@onready var attributes_label: Label = %AttributesManagerLabel
@onready var background_label: Label = %BackgroundLabel
@onready var perks_container: VBoxContainer = %PerksContainer

var ponygirl: Ponygirl
var pony_mod_bonus: int


func _ready() -> void :
	super ()
	PonygirlManager.focused_ponygirl = ponygirl
	if not GlobalSignals.update_ponygirls.is_connected(_update):
		GlobalSignals.update_ponygirls.connect(_update)
	_setup_portrait()
	_update()


func _setup_portrait() -> void :
	if portrait == null:
		return
	# Compact portrait: fit texture height, no empty reserved band under the drawing.
	portrait.custom_minimum_size = Vector2(0, 0)
	portrait.custom_maximum_size = Vector2(360, 220)
	portrait.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	portrait.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR


func _update() -> void :
	pony_mod_bonus = ponygirl.get_mod_bonus()
	if portrait:
		var tex: Texture2D = ponygirl.get_display_texture()
		portrait.texture = tex
		portrait.visible = tex != null
		if tex != null:
			# Cap display size while keeping aspect; shrink empty vertical space.
			var max_w: float = 320.0
			var max_h: float = 200.0
			var tw: float = float(tex.get_width())
			var th: float = float(tex.get_height())
			if tw <= 0.0 or th <= 0.0:
				portrait.custom_minimum_size = Vector2(max_w, max_h)
			else:
				var scale: float = minf(max_w / tw, max_h / th)
				portrait.custom_minimum_size = Vector2(tw * scale, th * scale)
				portrait.custom_maximum_size = portrait.custom_minimum_size
	titel_label.set_meta("locale_dynamic", true)
	titel_label.text = Utils.translate("%s (Level %s %s)") % [
		ponygirl.name,
		ponygirl.level,
		Utils.translate(str(ponygirl.race)),
	]
	attributes_label.set_meta("locale_dynamic", true)
	# No debug portrait-state key (e.g. [happy_horny])
	attributes_label.text = Utils.translate("XP: %s / Arousal: %s / Loyalty: %s") % [
		ponygirl.xp,
		ponygirl.arousal,
		ponygirl.loyalty,
	]
	background_label.set_meta("locale_dynamic", true)
	background_label.text = Utils.translate("Eyes: %s / Hair: %s / Skin: %s") % [
		Utils.translate(ponygirl.eye_color),
		Utils.translate(ponygirl.hair_color),
		Utils.translate(ponygirl.skin_tone),
	]
	for child in perks_container.get_children():
		perks_container.remove_child(child)
		child.queue_free()
	for perk in ponygirl.perks:
		var label: = Label.new()
		var descriptions: = perk.get_full_description(ponygirl)
		var desc_parts: PackedStringArray = []
		for d in descriptions:
			desc_parts.append(Utils.translate(str(d)))
		label.text = "%s: %s" % [
			Utils.translate(perk.name),
			" / ".join(desc_parts),
		]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		perks_container.add_child(label)


func _on_care_for_btn_pressed() -> void :
	ModalManager.open_care_modal(ponygirl)


func _on_back_btn_pressed() -> void :
	close()
