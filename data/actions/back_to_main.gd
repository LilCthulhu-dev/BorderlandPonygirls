extends Action
class_name BackToMain

func use():
	super()
	LocationManager.current_event = null
	SceneManager.change_scene(SceneManager.MAIN_WINDOW)
