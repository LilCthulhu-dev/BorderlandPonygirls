extends DefaultBtn

var content : EventBtn

func _ready() -> void:
	super()

func _on_pressed() -> void:
	EventManager.current_event = null
	SceneManager.change_scene(SceneManager.MAIN_WINDOW)
