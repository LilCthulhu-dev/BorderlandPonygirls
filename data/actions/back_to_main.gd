extends Action
class_name BackToMain

func use():
	LocationManager.current_event = null
	SceneManager.change_scene(SceneManager.MAIN_WINDOW)
