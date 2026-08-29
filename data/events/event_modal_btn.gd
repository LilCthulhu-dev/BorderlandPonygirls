extends _EventContent
class_name EventModalBtn

@export var _btn_text: String
var btn_text: String:
	set(value):
		_btn_text = value
	get:
		return Utils.translate(_btn_text)

@export_multiline var _modal_text: String
var modal_text: String:
	set(value):
		_modal_text = value
	get:
		return Utils.translate(_modal_text)

@export var actions : Array[Action]
