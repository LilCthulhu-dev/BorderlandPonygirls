extends CanvasLayer

@onready var label_titel: Label = %LabelTitel
@onready var label_description: Label = %LabelDescription
@onready var label_results: Label = %LabelResults
@onready var content_container: VBoxContainer = %ContentContainer
@onready var content_image: TextureRect = %ContentImage

const EVENT_BTN = preload("uid://boeoqj8wswe7u")
const EVENT_CHECK = preload("uid://dheu6x3a5wmi3")
const EVENT_TEXT = preload("uid://desp1eu87yxct")

func _ready() -> void:
	GameData.game_state = Enums.GAME_STATES.EVENT
	GlobalSignals.update_event.connect(_update_content)
	_update_content()

func _update_content():
	label_titel.text = Utils.translate(EventManager.current_event.titel)
	label_titel.visible = label_titel.text != ""

	label_description.text = Utils.translate(EventManager.current_event.description)
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

	for child in content_container.get_children():
		child.queue_free()

	var added_content := 0

	for content in EventManager.current_event.content:
		if !content.hard_requierments_met(): continue
		if content is EventPonySelect:
			added_content += _add_pony_select(content)
			continue
		var n = null
		if content is EventBtn:
			n = EVENT_BTN.instantiate()
		elif content is EventCheck:
			n = EVENT_CHECK.instantiate()
		else:
			n = EVENT_TEXT.instantiate()
		n.content = content
		content_container.add_child(n)
		added_content += 1

	if added_content == 0:
		var back_button := EVENT_BTN.instantiate()
		back_button.content = null
		content_container.add_child(back_button)


func _add_pony_select(select: EventPonySelect) -> int:
	var count := 0
	for pony in PonygirlManager.get_active_ponygirls():
		var ebtn := EventBtn.new()
		ebtn.txt = Utils.translate(select.button_txt) % pony.name
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
