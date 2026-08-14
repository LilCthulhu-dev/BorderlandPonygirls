extends StoryPage

@onready var titel_label: Label = %TitelLabel
@onready var description_label: Label = %DescriptionLabel
@onready var image: TextureRect = %Image
@onready var test_btn: DefaultBtn = %TestBtn
@onready var quest_btns: VBoxContainer = %QuestBtns

const LOCATION_BTN = preload("uid://opy75q5d44yi")

func _ready() -> void:
	super()
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_on):
		GlobalSignals.language_changed.connect(_on)
	_on()

func _on() -> void:
	super()
	if not LocationManager.current_location: return
	test_btn.visible = GameData.TESTING
	Utils.set_dynamic_label(titel_label, LocationManager.current_location.title)
	Utils.set_dynamic_label(description_label, LocationManager.current_location.description)
	image.texture = LocationManager.current_location.image
	_update_quest_btns()

func _update_quest_btns() -> void:
	for c in quest_btns.get_children():
		c.queue_free()
	for e in LocationManager.current_location.quest_events:
		if not e.requirements_are_met(): continue

		var b := LOCATION_BTN.instantiate()
		var qtitle: String = Utils.translate(e.titel)
		if b.has_method("set_source_text"):
			b._source_text = "> Quest: %s"
			b.text = Utils.translate("> Quest: %s") % qtitle
		else:
			b.text = Utils.translate("> Quest: %s") % qtitle
		quest_btns.add_child(b)

		var ce := ChangeEvent.new()
		ce.event_path = e.resource_path
		b.actions.push_back(ce)
	quest_btns.visible = quest_btns.get_child_count() > 0
