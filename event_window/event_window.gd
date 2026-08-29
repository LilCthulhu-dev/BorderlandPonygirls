extends CanvasLayer

@onready var label_titel: Label = %LabelTitel
@onready var label_description: Label = %LabelDescription
@onready var label_results: Label = %LabelResults
@onready var content_container: VBoxContainer = %ContentContainer
@onready var content_image: TextureRect = %ContentImage

const EVENT_BTN = preload("uid://boeoqj8wswe7u")
const EVENT_CHECK = preload("uid://dheu6x3a5wmi3")
const EVENT_TEXT = preload("uid://desp1eu87yxct")
const EVENT_MODAL_INFO = preload("uid://cvv8ckw6e40ou")

func _ready() -> void:
	GameData.game_state = Enums.GAME_STATES.EVENT
	GlobalSignals.update_event.connect(_update_content)
	_update_content()

func _update_content():
	label_titel.text = LocationManager.current_event.titel
	label_titel.visible = label_titel.text != ""

	label_description.text = LocationManager.current_event.description
	label_description.visible = label_description.text != ""

	label_results.text = ""
	if !LocationManager.current_event.open_actions.is_empty():
		for action in LocationManager.current_event.open_actions:
			var result_txt = action.get_result()
			if result_txt == "": continue
			if label_results.text != "":
				label_results.text += "\n"
			label_results.text += result_txt
			if action is AddDescription:
				label_results.text += "\n"
	label_results.visible = label_results.text != ""

	content_image.texture = LocationManager.current_event.img if content_image else null

	Utils.clear_container(content_container)
	for content in LocationManager.current_event.content:
		if !content.hard_requierments_met(): continue
		if content is EventPonySelect:
			_add_pony_select(content)
		elif content is EventInfo:
			_spawn_content(EVENT_MODAL_INFO, content)
		elif content is EventBtn:
			_spawn_content(EVENT_BTN, content)
		elif content is EventCheck:
			_spawn_content(EVENT_CHECK, content)
		else:
			_spawn_content(EVENT_TEXT, content)
	if content_container.get_child_count() <= 0:
		var back_button := EVENT_BTN.instantiate()
		back_button.content = null
		content_container.add_child(back_button)

func _spawn_content(blueprint : PackedScene, content):
	var inst = blueprint.instantiate()
	inst.content = content
	content_container.add_child(inst)

func _add_pony_select(select: EventPonySelect) -> void:
	for pony in PonygirlManager.get_active_ponygirls():
		var ebtn := EventBtn.new()
		ebtn.txt = select.button_txt % pony.name
		var focus := SetFocusedPonygirl.new()
		focus.pony = pony
		focus.hide_tooltip = true
		focus.hide_description = true
		var acts: Array[Action] = [focus]
		acts.append_array(select.actions)
		ebtn.actions = acts
		var n := EVENT_BTN.instantiate()
		n.content = ebtn
		content_container.add_child(n)

func _add_back_to_main_btn():
	if content_container.get_child_count() > 0: return
	var back_button := EVENT_BTN.instantiate()
	back_button.content = null
	content_container.add_child(back_button)
