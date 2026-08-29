extends _EventContent
class_name EventSwitchContentBtn

@export var _btn_text: String
var btn_text: String:
	set(value):
		_btn_text = value
	get:
		return Utils.translate(_btn_text)
@export_multiline var _new_content_text = ""
var new_content_text:
	set(value):
		_new_content_text = value
	get:
		return Utils.translate(_new_content_text)

@export var actions : Array[Action]
@export var end_conversation = false
@export var single_use = false
var used = false
