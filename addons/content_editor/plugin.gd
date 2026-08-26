@tool
extends EditorPlugin

func _enter_tree() -> void:
	print("Content Editor enabled")

func _exit_tree() -> void:
	print("Content Editor disabled")
