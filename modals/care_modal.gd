extends Modal

@onready var name_label: Label = %NameLabel
@onready var attributes_label: Label = %AttributesManagerLabel
@onready var training_btn: DefaultBtn = %TrainingBtn
@onready var teasing_btn: DefaultBtn = %TeasingBtn
@onready var climax_btn: DefaultBtn = %ClimaxBtn

var ponygirl : Ponygirl

func _ready() -> void:
	super()
	if ponygirl is not Ponygirl: queue_free()
	name_label.text = "%s (Level %s %s)" % [
		ponygirl.name,
		ponygirl.level,
		ponygirl.race
	]
	attributes_label.text = "XP: %s / Arousal: %s / Loyalty: %s" % [
		ponygirl.xp,
		ponygirl.arousal,
		ponygirl.loyalty
	]
	var btns = [training_btn, teasing_btn, climax_btn]
	var array_of_actions = [
		GameData.training_actions,
		GameData.teasing_actions,
		GameData.climax_actions]
	for i in btns.size():
		var btn = btns[i]
		var actions = array_of_actions[i]
		btn.disabled = !Utils.requierments_met(actions)
		btn.tooltip = "\n".join(TooltipManager.get_tooltips(actions))

func _on_back_to_pony_btn_pressed() -> void:
	ModalManager.open_ponygirl_modal(ponygirl)

func _on_back_to_stable_btn_pressed() -> void:
	close()

func _on_training_btn_pressed() -> void:
	ModalManager.open_care_result_modal(GameData.training_actions)

func _on_teasing_btn_pressed() -> void:
	ModalManager.open_care_result_modal(GameData.teasing_actions)

func _on_climax_btn_pressed() -> void:
	ModalManager.open_care_result_modal(GameData.climax_actions)
