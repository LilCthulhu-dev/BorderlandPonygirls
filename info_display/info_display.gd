extends CanvasLayer

@onready var info_container: VBoxContainer = %InfoContainer

const INFO_LABEL = preload("uid://cmmq0awmyel50")
var info_delay := 0.1
var info_queue: Array[String] = []
var is_processing_queue := false

func _ready() -> void:
	GlobalSignals.add_info.connect(_on_add_info)

func _on_add_info(txt: String) -> void:
	info_queue.append(txt)
	if not is_processing_queue:
		_process_info_queue()

func _process_info_queue() -> void:
	is_processing_queue = true
	while not info_queue.is_empty():
		var txt: String = info_queue.pop_front()
		var label: Label = INFO_LABEL.instantiate() as Label
		label.text = txt
		info_container.add_child(label)
		await get_tree().create_timer(info_delay).timeout
	is_processing_queue = false
