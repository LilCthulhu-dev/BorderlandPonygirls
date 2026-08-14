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
	GlobalSignals.update_ponygirls.connect(_update)
	_update()

func _update() -> void :
	pony_mod_bonus = ponygirl.get_mod_bonus()
	_update_title()
	_update_portrait()
	_update_attributes()
	_update_backgrounds()
	_update_perks()

func _update_title():
	titel_label.text = Utils.translate("%s (Level %s %s)") % [
		ponygirl.name,
		ponygirl.level,
		Utils.translate(str(ponygirl.race)),
	]

func _update_portrait():
	var tex: Texture2D = ponygirl.portrait
	portrait.texture = tex
	portrait.visible = tex != null

func _update_attributes():
	attributes_label.text = Utils.translate("XP: %s / Arousal: %s / Loyalty: %s") % [
		ponygirl.xp,
		ponygirl.arousal,
		ponygirl.loyalty,
	]

func _update_backgrounds():
	background_label.text = Utils.translate("Eyes: %s / Hair: %s / Skin: %s") % [
		Utils.translate(str(ponygirl.eye_color)),
		Utils.translate(str(ponygirl.hair_color)),
		Utils.translate(str(ponygirl.skin_tone)),
	]

func _update_perks():
	for child in perks_container.get_children():
		perks_container.remove_child(child)
		child.queue_free()
	for perk in ponygirl.perks:
		var label: = Label.new()
		var descriptions: = perk.get_full_description(ponygirl)
		label.text = "%s: %s" % [Utils.translate(perk.name), " / ".join(descriptions)]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		perks_container.add_child(label)

func _on_care_for_btn_pressed() -> void :
	ModalManager.open_care_modal(ponygirl)

func _on_back_btn_pressed() -> void :
	close()
