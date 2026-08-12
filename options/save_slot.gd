extends HBoxContainer

@onready var name_label: Label = %NameLabel
@onready var save_btn: DefaultBtn = %SaveBtn
@onready var load_btn: DefaultBtn = %LoadBtn

@export var slot_number := 0

func _ready() -> void:
	_update_slot()

func _update_slot() -> void:
	save_btn.visible = slot_number != 0
	save_btn.disabled = GameData.game_state == Enums.GAME_STATES.START
	load_btn.disabled = not SaveGame.save_exists(slot_number)
	var slot_name := "Autosave" if slot_number == 0 else "Slot %s" % slot_number
	if not SaveGame.save_exists(slot_number):
		name_label.text = "%s\n- Empty -" % slot_name
		return
	var save_info := SaveGame.load_info(slot_number)
	if save_info == null:
		name_label.text = "%s\nInvalid save" % slot_name
		return
	name_label.text = "%s (%s)\n%s %s" % [
		slot_name,
		save_info.save_date,
		save_info.boss_title,
		save_info.boss_name,
	]

func _on_save_btn_pressed() -> void:
	SaveGame.save(slot_number)
	_update_slot()

func _on_load_btn_pressed() -> void:
	var save_game := SaveGame.load(slot_number)
	if save_game == null:
		return
	GameData.save_game = save_game
	SceneManager.change_scene(SceneManager.MAIN_WINDOW)
