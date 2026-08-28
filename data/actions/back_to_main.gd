extends Action
class_name BackToMain

func use():
	super()
	EventManager.current_event = null
	SceneManager.change_scene(SceneManager.MAIN_WINDOW)
