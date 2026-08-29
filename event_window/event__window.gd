extends CanvasLayer

@onready var label_titel: Label = %LabelTitel
@onready var label_description: Label = %LabelDescription
@onready var label_results: Label = %LabelResults
@onready var content_container: VBoxContainer = %ContentContainer
@onready var content_image: TextureRect = %ContentImage

const EVENT__BTN = preload("uid://boeoqj8wswe7u")
const EVENT__CHECK = preload("uid://dheu6x3a5wmi3")
const EVENT__TEXT = preload("uid://desp1eu87yxct")
const EVENT__MODAL_BTN = preload("uid://cvv8ckw6e40ou")
const EVENT__MOVE_BTN = preload("uid://b312y4kwwux86")
const EVENT__RETURN_TO_MAIN_BTN = preload("uid://c27j1lrumf1l6")
const EVENT__SWITCH_CONTENT_BTN = preload("uid://g263eaqprilm")

func _ready() -> void:
	GameData.game_state = Enums.GAME_STATES.EVENT
	GlobalSignals.update_event.connect(_update_content)
	_update_content()

func _update_content():
	label_titel.text = EventManager.current_event.titel
	label_titel.visible = label_titel.text != ""

	label_description.text = EventManager.current_event.description
	label_description.visible = label_description.text != ""

	label_results.text = ""
	if !EventManager.current_event.open_actions.is_empty():
		for action in EventManager.current_event.open_actions:
			var result_txt = action.get_result()
			if result_txt == "": continue
			if label_results.text != "":
				label_results.text += "\n"
			label_results.text += result_txt
			if action is AddDescription:
				label_results.text += "\n"
	label_results.visible = label_results.text != ""

	content_image.texture = EventManager.current_event.img if content_image else null

	Utils.clear_container(content_container)
	for content in EventManager.current_event.content:
		if !content.hard_requierments_met():
			continue
		if content.single_use && content.used:
			continue
		elif content is EventPonySelect:
			_add_pony_select(content)
		elif content is EventSwitchContentBtn:
			_spawn_content(EVENT__SWITCH_CONTENT_BTN, content)
		elif content is EventModalBtn:
			_spawn_content(EVENT__MODAL_BTN, content)
		elif content is EventMoveBtn:
			_spawn_content(EVENT__MOVE_BTN, content)
		elif content is EventBtn:
			_spawn_content(EVENT__BTN, content)
		elif content is EventCheck:
			_spawn_content(EVENT__CHECK, content)
		else:
			_spawn_content(EVENT__TEXT, content)
	if content_container.get_child_count() <= 0:
		var back_button := EVENT__RETURN_TO_MAIN_BTN.instantiate()
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
		var n := EVENT__BTN.instantiate()
		n.content = ebtn
		content_container.add_child(n)

func _add_back_to_main_btn():
	if content_container.get_child_count() > 0: return
	var back_button := EVENT__BTN.instantiate()
	back_button.content = null
	content_container.add_child(back_button)
