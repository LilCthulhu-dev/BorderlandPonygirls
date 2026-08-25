extends ColorRect

@onready var texture_rect: TextureRect = %TextureRect
var flag : Flag

func _ready() -> void:
	if flag == null:
		queue_free()
		return
	texture_rect.texture = flag.image

func _on_mouse_entered() -> void:
	if flag.description:
		var txt = flag.description
		if flag.weight > 0:
			txt += "\n- Adds %s weight to inventory." % flag.weight
		TooltipManager.add(txt)

func _on_mouse_exited() -> void:
	TooltipManager.remove()
