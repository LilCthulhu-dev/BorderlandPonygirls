@tool
extends EditorPlugin

const CONTENT_EDITOR = preload("uid://b1rmg7548o7lk")
var editor: Control

func _enter_tree() -> void:
	editor = CONTENT_EDITOR.instantiate() as Control
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, editor)
	print("Content Editor enabled")

func _exit_tree() -> void:
	remove_control_from_docks(editor)
	editor.queue_free()
	print("Content Editor disabled")
