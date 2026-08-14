extends Node2D
class_name LocationMarker

@onready var titel_label: Label = $TitelLabel
@export var location : Location

func _ready() -> void:
	if not location: queue_free()
	process_mode = Node.PROCESS_MODE_ALWAYS
	titel_label.text = Utils.translate(location.title)
	if GlobalSignals and not GlobalSignals.language_changed.is_connected(_refresh_title):
		GlobalSignals.language_changed.connect(_refresh_title)
	LocationManager.location_markers[location.id] = self


func _refresh_title() -> void:
	if location and titel_label:
		titel_label.text = Utils.translate(location.title)
