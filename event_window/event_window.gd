extends CanvasLayer

@onready var label_titel: Label = %LabelTitel
@onready var label_description: Label = %LabelDescription
@onready var label_results: Label = %LabelResults
@onready var content_container: VBoxContainer = %ContentContainer
@onready var content_image: TextureRect = %ContentImage

const EVENT_BTN = preload("uid://boeoqj8wswe7u")
const EVENT_CHECK = preload("uid://dheu6x3a5wmi3")
const EVENT_TEXT = preload("uid://desp1eu87yxct")

const EVENT_INFO = preload("uid://c3424ov14be65")
const EVENT_CHANGE = preload("uid://d07s2ty62gysc")

const BACK_TO_MAIN_BTN = preload("uid://objbp62gh8w")

var event:
	get:
		return LocationManager.current_event

func _ready() -> void:
	GameData.game_state = Enums.GAME_STATES.EVENT
	GlobalSignals.update_event.connect(_update_content)
	_update_content()

func _update_content():
	label_titel.text = event.titel
	label_titel.visible = label_titel.text != ""

	label_description.text = event.description
	label_description.visible = label_description.text != ""

	label_results.text = ""
	if !event.open_actions.is_empty():
		for action in event.open_actions:
			var result_txt = action.get_result()
			if result_txt == "": continue
			if label_results.text != "":
				label_results.text += "\n"
			label_results.text += result_txt
			if action is AddDescription:
				label_results.text += "\n"
	label_results.visible = label_results.text != ""

	content_image.texture = event.img if content_image else null

	Utils.clear_container(content_container)
	_add_content()
	_add_back_to_main()

func _add_content() -> void:
	for content in event.content:
		if not content.hard_requierments_met():
			continue
		if content.used:
			continue
		if content is EventPonySelect:
			_add_pony_select(content)
		elif content is EventBtn:
			_inst_content(EVENT_BTN, content)
		elif content is EventCheck:
			_inst_content(EVENT_CHECK, content)
		elif content is EventInfo:
			_inst_content(EVENT_INFO, content)
		elif content is EventChange:
			_inst_content(EVENT_CHANGE, content)
		elif content is EventText:
			_inst_content(EVENT_TEXT, content)

func _inst_content(element: PackedScene, content: _EventContent):
	var n = element.instantiate()
	n.content = content
	content_container.add_child(n)

func _add_back_to_main():
	if not (event.content.is_empty() or event.add_back_to_main): return
	content_container.add_child(BACK_TO_MAIN_BTN.instantiate())

func _add_pony_select(select: EventPonySelect) -> int:
	var count := 0
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
		count += 1
	return count
