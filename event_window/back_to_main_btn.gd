extends DefaultBtn

func _on_pressed() -> void:
	LocationManager.current_event = null
	SceneManager.change_scene(SceneManager.MAIN_WINDOW)
