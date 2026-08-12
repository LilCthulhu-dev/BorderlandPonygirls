extends Modal

@onready var description: Label = %Description

func _ready() -> void:
	super()
	AudioManager.play("fail1")
	description.text = Utils.translate(description.text)

func _on_button_pressed() -> void:
	SceneManager.change_scene(SceneManager.START_MENU)
