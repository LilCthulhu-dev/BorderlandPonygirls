extends Node2D
class_name LocationMarker

@onready var titel_label: Label = $TitelLabel
@export var location : Location

func _ready() -> void:
	if not location: queue_free()
	process_mode = Node.PROCESS_MODE_ALWAYS
	titel_label.text = location.title
	LocationManager.location_markers[location.id] = self
