extends CanvasLayer

@onready var resultcontainer: VBoxContainer = %Resultcontainer

const RESULT_LABEL = preload("uid://dct0clbth1pfa")

var info_delay := 0.2
var info_queue: Array[String] = []
var is_processing_queue := false

func _ready() -> void:
	GlobalSignals.add_info.connect(_on_add_info)

func _on_add_info(txt: String) -> void:
	if GameData.game_state == Enums.GAME_STATES.START:
		return
	if GameData.game_state == Enums.GAME_STATES.MAIN:
		return
	if GameData.game_state == Enums.GAME_STATES.COMBAT:
		return
	info_queue.append(txt)
	if not is_processing_queue:
		_process_info_queue()

func _process_info_queue() -> void:
	is_processing_queue = true
	while not info_queue.is_empty():
		var txt: String = info_queue.pop_front()
		var label: Label = RESULT_LABEL.instantiate() as Label
		label.text = txt
		resultcontainer.add_child(label)
		await get_tree().create_timer(info_delay).timeout
	is_processing_queue = false
