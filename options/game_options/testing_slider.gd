extends CheckButton

func _ready() -> void:
	button_pressed = GameData.TESTING

func _on_pressed() -> void:
	GameData.TESTING = !GameData.TESTING
