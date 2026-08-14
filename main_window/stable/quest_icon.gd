extends ColorRect

@onready var texture_rect: TextureRect = %TextureRect
var flag : Flag

func _ready() -> void:
	if flag is not Flag:
		queue_free()
		return
	texture_rect.texture = flag.image

func _on_mouse_entered() -> void:
	if flag.description:
		TooltipManager.add(flag.description)

func _on_mouse_exited() -> void:
	TooltipManager.remove()
